module TopModule(
    input  clk,
    input  a,
    output q
);

reg prev_a;
reg q;

always @(posedge clk) begin
    if (a == 1 && prev_a == 0) begin
        q <= ~q;
    end
    prev_a <= a;
end

initial begin
    q = 1;
    prev_a = 0;
end

endmodule