module TopModule(
    input clk,
    input a,
    input b,
    output reg state,
    output q
);

wire next_state;

assign next_state = state ^ b;  // toggle state when b=1
assign q = state;

always @(posedge clk) begin
    state <= next_state;
end

initial state = 1'b0;

endmodule