module TopModule (
  input clk,
  input areset,
  input load,
  input ena,
  input [3:0] data,
  output reg [3:0] q
);

  reg [1:0] state;

  always @(posedge clk or posedge areset)
  begin
    if (areset)
      state <= 2'b00;
    else
    begin
      case(state)
        2'b00:
          begin
            if (load)
              q <= data;
            state <= 2'b01; // move to next state
          end
        2'b01: // Shift register operation
          begin
            if (ena)
              q <= {q[3], q[3:1]};
            state <= 2'b01; // stay in the same state
          end
      endcase
    end
  end

endmodule