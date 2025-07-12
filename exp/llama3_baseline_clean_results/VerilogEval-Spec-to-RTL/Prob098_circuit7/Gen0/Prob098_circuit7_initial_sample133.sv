module TopModule(
    input  clk,
    input  a,
    output q
);

reg q;
reg prev_a;

always @(posedge clk) begin
    prev_a <= a;
    if (a && prev_a) begin
        q <= ~q;
    end
end

initial begin
    prev_a = 0;
    q = 1;
end

endmodule