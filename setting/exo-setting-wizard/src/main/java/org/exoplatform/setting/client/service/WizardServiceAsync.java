package org.exoplatform.setting.client.service;

import java.util.List;
import java.util.Map;

import com.google.gwt.user.client.rpc.AsyncCallback;


public interface WizardServiceAsync {
  
  void storeDatas(Map<String, String> datas, Integer toStep, AsyncCallback<Integer> callback);
  void getSystemProperties(AsyncCallback<Map<String, String>> callback);
  void getDatasources(AsyncCallback<List<String>> callback);
}
