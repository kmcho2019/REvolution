module TopModule(
    input  clk,
    input  ar,
    input  d,
    output reg q
);

reg internal_q;

always @(posedge clk or posedge ar) begin
    if (ar) begin
        internal_q <= 1'b0; // Reset internal stage
        q <= 1'b0; // Reset output
    end else if (posedge clk) begin
        internal_q <= d; // Capture data on positive clock edge
        q <= internal_q; // Update output
    end
end

endmodule