module TopModule(
    input clk,
    input a,
    input b,
    output reg state,
    output q
);

wire next_state = b & ~a;

assign q = state | (a & b);

always @(posedge clk) begin
    state <= next_state;
end

initial begin
    state = 1'b0;
end

endmodule