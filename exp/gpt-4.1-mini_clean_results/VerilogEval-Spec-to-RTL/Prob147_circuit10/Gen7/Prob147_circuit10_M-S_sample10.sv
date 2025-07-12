module TopModule (
    input clk,
    input a,
    input b,
    output reg state,
    output q
);

wire next_state;

assign next_state = b ? 1'b0 : state ^ a;
assign q = state;

always @(posedge clk) begin
    state <= next_state;
end

initial begin
    state = 0;
end

endmodule