module TopModule(
    input clk,
    input d,
    output q
);

reg internal_q;

always @(posedge clk or negedge clk) begin
    // This approach is conceptually simpler but may not synthesize correctly.
    // For synthesis, consider using a single-edge triggered flip-flop and additional logic.
    internal_q <= d;
end

assign q = internal_q;

endmodule