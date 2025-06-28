module TopModule (
  input clk,
  input reset,
  input in,
  output reg disc,
  output reg flag,
  output reg err
);

reg [2:0] state;

always @(posedge clk or posedge reset) begin
  if (reset) begin
    state <= 3'b000;
    disc <= 0;
    flag <= 0;
    err <= 0;
  end
  else begin
    case (state)
      3'b000: begin // State S0: Looking for flag (01111110) or error condition
        if (in) state <= 3'b001; // Transition to State S1
        else state <= 3'b000; // Stay in State S0
        disc <= 0;
        flag <= (in == 0) ? 1 : 0; // Set flag when input is 0
        err <= 0;
      end
      3'b001: begin // State S1: Handling error condition
        if (in) state <= 3'b001; // Stay in State S1
        else state <= 3'b000; // Transition back to State S0
        disc <= (in == 1) ? 1 : 0; // Set disc when input is 1
        flag <= 0;
        err <= (in == 0) ? 1 : 0; // Set err when input is 0
      end
    endcase
  end
end

endmodule