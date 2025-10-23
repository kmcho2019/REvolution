module TopModule (
    input         clk,
    input         reset,
    output [2:0]  ena,
    output [15:0] q
);

    reg [3:0] digit0, digit1, digit2, digit3;  // Ones, Tens, Hundreds, Thousands
    reg       inc_upper; // Flag to indicate upper digit increment cycle

    // Enable signals combinationally indicate when upper digits are enabled to increment:
    // ena[0]: increment tens when ones digit is 9
    // ena[1]: increment hundreds when ones and tens digits are 9
    // ena[2]: increment thousands when ones, tens, and hundreds digits are 9
    assign ena[0] = (digit0 == 4'd9);
    assign ena[1] = ena[0] && (digit1 == 4'd9);
    assign ena[2] = ena[1] && (digit2 == 4'd9);

    // Pack digits into output
    assign q = {digit3, digit2, digit1, digit0};

    always @(posedge clk) begin
        if (reset) begin
            digit0    <= 4'd0;
            digit1    <= 4'd0;
            digit2    <= 4'd0;
            digit3    <= 4'd0;
            inc_upper <= 1'b0;
        end else begin
            if (inc_upper == 1'b0) begin
                // Phase 1: increment ones digit
                if (digit0 == 4'd9) begin
                    digit0 <= 4'd0;
                    inc_upper <= 1'b1; // Next cycle increment upper digits if needed
                end else begin
                    digit0 <= digit0 + 4'd1;
                    inc_upper <= 1'b0; // No upper increment needed
                end
            end else begin
                // Phase 2: increment upper digits according to carry
                inc_upper <= 1'b0; // Return to phase 1 next cycle

                if (ena[1]) begin
                    // Ones and tens digits are 9, need to increment hundreds
                    if (ena[2]) begin
                        // Also hundreds digit is 9, increment thousands
                        if (digit3 == 4'd9) begin
                            digit3 <= 4'd0;
                        end else begin
                            digit3 <= digit3 + 4'd1;
                        end
                        digit2 <= 4'd0;
                    end else begin
                        if (digit2 == 4'd9)
                            digit2 <= 4'd0;
                        else
                            digit2 <= digit2 + 4'd1;
                    end
                    digit1 <= 4'd0;
                end else if (ena[0]) begin
                    // Only ones digit was 9, increment tens digit
                    if (digit1 == 4'd9) begin
                        digit1 <= 4'd0;
                    end else begin
                        digit1 <= digit1 + 4'd1;
                    end
                    // digits2 and digit3 unchanged
                end
                // else no upper digit increment needed
            end
        end
    end

endmodule