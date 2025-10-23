module TopModule (
    input clk,
    input reset,
    input w,
    output z
);

    // Decision tree state tracking registers
    reg level1;  // First decision level (A/B vs others)
    reg level2;  // Second decision level (C/D/E/F)

    // Output is combinatorial function of decision levels
    assign z = level1 & (level2 ^ w);  // Optimized output logic

    always @(posedge clk) begin
        if (reset) begin
            level1 <= 0;
            level2 <= 0;
        end else begin
            case ({level1, level2})
                // State A equivalent
                2'b00: begin
                    level1 <= w ? 1'b0 : 1'b0;  // Stay A or move to B
                    level2 <= w ? 1'b0 : 1'b1;
                end
                // State B equivalent
                2'b01: begin
                    level1 <= w ? 1'b1 : 1'b1;  // Move to D or C
                    level2 <= w ? 1'b0 : 1'b1;
                end
                // State C equivalent
                2'b11: begin
                    level1 <= w ? 1'b1 : 1'b1;  // Move to D or E
                    level2 <= w ? 1'b0 : 1'b0;
                end
                // State D equivalent
                2'b10: begin
                    level1 <= w ? 1'b0 : 1'b1;  // Move to A or F
                    level2 <= w ? 1'b0 : 1'b0;
                end
                // State E equivalent
                2'b10: begin
                    level1 <= w ? 1'b1 : 1'b1;  // Stay E or move to D
                    level2 <= w ? 1'b0 : 1'b0;
                end
                // State F equivalent
                2'b10: begin
                    level1 <= w ? 1'b1 : 1'b1;  // Move to D or C
                    level2 <= w ? 1'b0 : 1'b1;
                end
            endcase
        end
    end

endmodule