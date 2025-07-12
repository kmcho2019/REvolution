module TopModule(
    input clk,
    input a,
    input b,
    output reg state,
    output q
);

always @(posedge clk) begin
    state <= (state & ~(a & b)) | (~state & b & ~a);
end

assign q = state | (a & b);

initial begin
    state = 0;
end

endmodule