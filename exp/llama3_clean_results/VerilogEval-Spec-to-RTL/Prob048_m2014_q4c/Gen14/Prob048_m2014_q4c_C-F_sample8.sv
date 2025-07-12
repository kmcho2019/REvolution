module TopModule(
    input  clk,
    input  d,
    input  r,
    output reg q
);

always @(posedge clk) begin
    // Using the conditional operator for concise and potentially efficient synthesis
    q <= (r) ? 1'b0 : d;
end

endmodule