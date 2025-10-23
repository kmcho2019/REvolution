module TopModule(
    input clk,
    input a,
    input b,
    output q,
    output reg state
);

reg next_state;

assign next_state = (!a && !b) ? 1 : (a && b) ? 0 : state;
assign q = (state) ? 1 : b;

always @(posedge clk) begin
    state <= next_state;
end

initial begin
    state = 1'b0;
end

endmodule