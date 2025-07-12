module TopModule (
    input clk,
    input areset,
    input j,
    input k,
    output reg out
);

    // Toggle-based implementation
    wire toggle = (out & k) | (~out & j);

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            out <= 1'b0;  // Async reset to OFF
        end else if (toggle) begin
            out <= ~out;  // Toggle state when conditions met
        end
    end

endmodule