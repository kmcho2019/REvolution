module TopModule (
  input clk,
  input j,
  input k,
  input reset,
  output reg out
);

parameter OFF = 2'b00;
parameter ON = 2'b01;

reg [1:0] state, next_state;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= OFF;
    end else begin
        state <= next_state;
    end
end

always @* begin
    case (state)
        OFF: next_state = (j) ? ON : OFF;
        ON: next_state = (k) ? OFF : ON;
    endcase
end

always @* begin
    case (state)
        OFF: out = 1'b0;
        ON: out = 1'b1;
    endcase
end

endmodule