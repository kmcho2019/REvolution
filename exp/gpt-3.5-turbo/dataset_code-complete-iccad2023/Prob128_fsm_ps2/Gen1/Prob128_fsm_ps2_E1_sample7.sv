module TopModule (
  input clk,
  input [7:0] in,
  input reset,
  output reg done
);

// Define states
parameter IDLE = 1'b0;
parameter SEARCH = 1'b1;

// Define signals
reg state;
reg [2:0] in_count;

// State transition and outputs
always @(posedge clk or posedge reset) begin
  if (reset)
    state <= IDLE;
  else if (state == IDLE && in[3] == 1)
    state <= SEARCH;
  else if (state == SEARCH && in[3] == 1 && in_count == 2)
    begin
      state <= IDLE;
      done <= 1;
    end
  else if (state == SEARCH && in[3] == 1)
    in_count <= in_count + 1;
  else if (state == SEARCH)
    in_count <= 0;
end

endmodule