module TopModule (
  input mode,
  input too_cold,
  input too_hot,
  input fan_on,
  output heater,
  output aircon,
  output fan
);
  
  // Initialize outputs
  assign heater = 0;
  assign aircon = 0;
  assign fan = fan_on;
  
  always @*
  begin
    if (mode == 1) begin // Heating mode
      if (too_cold) begin
        heater = 1;
        fan = 1;
      end
      else begin
        heater = 0;
        fan = fan_on;
      end
    end
    else begin // Cooling mode
      if (too_hot) begin
        aircon = 1;
        fan = 1;
      end
      else begin
        aircon = 0;
        fan = fan_on;
      end
    end
  end

endmodule