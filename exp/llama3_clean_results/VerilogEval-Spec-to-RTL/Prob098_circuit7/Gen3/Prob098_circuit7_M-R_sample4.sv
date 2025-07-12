module TopModule(
    input  clk,
    input  a,
    output reg q
);

always @(posedge clk) begin
    if (a) begin
        q <= ~q; // Toggle q when a is 1
    end
end

endmodule