module TopModule (
    input clk,
    input a,
    input b,
    output reg state,
    output q
);

wire next_state;

assign next_state = (state ^ a) & (~b);
assign q = state;  // output q reflects current state

always @(posedge clk) begin
    state <= next_state;
end

initial begin
    state = 1'b0;  // initialize state to 0
end

endmodule