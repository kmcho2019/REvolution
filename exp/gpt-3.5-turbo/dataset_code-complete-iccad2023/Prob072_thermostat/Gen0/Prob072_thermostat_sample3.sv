module TopModule (
  input mode,
  input too_cold,
  input too_hot,
  input fan_on,
  output heater,
  output aircon,
  output fan
);

  // By default, turn off all devices
  assign heater = 0;
  assign aircon = 0;
  
  // Fan is on if any device is on or if the user requests it
  assign fan = (heater || aircon || fan_on) ? 1 : 0;

  // Logic to control the devices based on mode and temperature conditions
  always @(*) begin
    if (mode == 1) begin
      if (too_cold) begin
        heater = 1;
      end
    end 
    else begin
      if (too_hot) begin
        aircon = 1;
      end
    end
  end

endmodule