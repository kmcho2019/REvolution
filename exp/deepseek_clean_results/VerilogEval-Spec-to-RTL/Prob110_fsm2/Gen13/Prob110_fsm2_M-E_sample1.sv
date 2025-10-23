module TopModule (
    input clk,
    input areset,
    input j,
    input k,
    output reg out
);

    // Toggle-based implementation
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            out <= 1'b0;  // Async reset to OFF
        end else begin
            // Toggle when:
            // (OFF and j=1) or (ON and k=1)
            out <= out ^ ((~out & j) | (out & k));
        end
    end

endmodule