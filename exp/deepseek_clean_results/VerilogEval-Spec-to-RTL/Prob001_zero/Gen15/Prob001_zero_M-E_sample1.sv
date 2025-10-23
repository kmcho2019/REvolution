module TopModule (
    output reg zero,
    input clk,    // Clock input
    input rst_n   // Active-low reset
);
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            zero <= 1'b0;  // Reset to LOW
        end else begin
            zero <= 1'b0;  // Maintain LOW state
        end
    end
endmodule