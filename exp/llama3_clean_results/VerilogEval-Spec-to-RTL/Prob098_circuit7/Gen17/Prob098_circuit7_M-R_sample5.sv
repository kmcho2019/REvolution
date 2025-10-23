module TopModule(
    input clk,
    input a,
    output reg q
);

reg prev_q;

initial begin
    prev_q = 1'b0;
end

always @(posedge clk) begin
    prev_q <= ~a;
end

assign q = prev_q;

endmodule