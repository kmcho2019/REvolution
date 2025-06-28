module TopModule (
  input clk,
  input reset,
  output reg shift_ena
);

reg [2:0] counter;
reg proper_pattern_detected;

// FSM states
parameter IDLE = 2'b00;
parameter COUNTING = 2'b01;

always @(posedge clk or posedge reset) begin
  if (reset) begin
    counter <= 0;
    shift_ena <= 0;
  end else begin
    case(counter)
      3: shift_ena <= 1; // Assert shift_ena for 4 cycles
      0, 1, 2: shift_ena <= 0; // Keep shift_ena low for other cycles
      default: shift_ena <= 0;
    endcase

    if (proper_pattern_detected) begin
      if (counter < 3) begin
        counter <= counter + 1;
      end else begin
        counter <= 0;
      end
    end else begin
      counter <= 0;
    end
  end
end

// Replace this with the proper logic to detect the desired bit pattern
always @(posedge clk) begin
  if (reset) begin
    proper_pattern_detected <= 0;
  end else begin
    // Add logic here to detect the proper bit pattern
    // proper_pattern_detected <= ?;
  end
end

endmodule