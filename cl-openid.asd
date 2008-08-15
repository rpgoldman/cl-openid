; -*- lisp -*-

(defpackage #:cl-openid.system
  (:use #:common-lisp #:asdf))
(in-package #:cl-openid.system)

(defsystem #:cl-openid
  :name "cl-openid"
  :description "cl-openid"
  :version "0.1"
  :author "Maciej Pasternacki"
  :maintainer "Maciej Pasternacki"
  :licence "LLGPL, see http://opensource.franz.com/preamble.html for details"

  :components
  ((:module #:src
            :serial t
            :components ((:file "package")
                         (:file "shared" :depends-on ("package"))
                         (:file "message" :depends-on ("package" "shared"))
                         (:file "association" :depends-on ("package" "shared" "message"))
                         (:file "authproc" :depends-on ("package" "shared" "message" "association"))
                         (:file "relying-party")
                         (:file "provider"))))
  :depends-on (#:hunchentoot #:drakma #:ironclad #:xmls #:split-sequence
                             #-allegro #:puri
                             #-allegro #:cl-html-parse
                             #:cl-base64 #:trivial-utf-8))

#+allegro
(defmethod asdf:perform :after ((op load-op)
                                (component (eql (find-system :cl-openid))))
  "Use Allegro's own version of ported libraries."
  (require 'uri)
  (require 'phtml))

(defsystem #:cl-openid.test
  :version "0.1"
  :description "Test suite for cl-openid"
  :components
  ((:module #:t
    :components ((:file "suite")
                 (:file "shared" :depends-on ("suite"))
                 (:file "message" :depends-on ("suite"))
                 (:file "authproc" :depends-on ("suite"))
                 (:file "association" :depends-on ("suite"))
                 (:file "provider" :depends-on ("suite")))))
  :depends-on (#:cl-openid #:fiveam))

(defmethod perform ((op asdf:test-op)
                    (system (eql (find-system :cl-openid))))
  "Perform unit tests for cl-openid"
  (asdf:operate 'asdf:load-op :cl-openid.test)
  (funcall (intern (string :run!) (string :it.bese.fiveam)) :cl-openid))
