module TopModule (
    input  clk,
    input  d,
    output q
);

reg q_rise, q_fall;

always @(posedge clk) begin
    q_rise <= d;
end

always @(negedge clk) begin
    q_fall <= d;
end

assign q = (q_rise | q_fall);

endmodule