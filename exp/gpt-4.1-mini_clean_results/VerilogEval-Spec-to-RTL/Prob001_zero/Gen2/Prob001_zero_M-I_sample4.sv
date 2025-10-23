module TopModule(output zero);
  // synthesis translate_off
  // No logic during simulation
  // synthesis translate_on
  (* keep = "true", keep_hierarchy = "true", dont_touch = "true" *) 
  wire zero_internal;
  assign zero_internal = 1'b0;
  assign zero = zero_internal;
endmodule