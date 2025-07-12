module TopModule(
    input  clk,
    input  d,
    input  r,
    output reg q
);

always @(posedge clk) begin
    // Ensure synchronous reset and data assignment
    q <= (r) ? 1'b0 : d;
end

endmodule