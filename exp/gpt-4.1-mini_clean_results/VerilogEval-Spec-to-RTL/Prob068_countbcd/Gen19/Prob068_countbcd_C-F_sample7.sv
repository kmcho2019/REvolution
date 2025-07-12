module TopModule (
    input         clk,
    input         reset,
    output [2:0]  ena,
    output [15:0] q
);

    reg [3:0] digit0, digit1, digit2, digit3;  // Ones, Tens, Hundreds, Thousands

    // Enable signals indicate when upper digits increment:
    // ena[0]: increment tens when ones digit is 9
    // ena[1]: increment hundreds when ones and tens digits are 9
    // ena[2]: increment thousands when ones, tens, and hundreds digits are 9
    assign ena[0] = (digit0 == 4'd9);
    assign ena[1] = ena[0] && (digit1 == 4'd9);
    assign ena[2] = ena[1] && (digit2 == 4'd9);

    // Combine digits into the 16-bit BCD output
    assign q = {digit3, digit2, digit1, digit0};

    always @(posedge clk) begin
        if (reset) begin
            digit0 <= 4'd0;
            digit1 <= 4'd0;
            digit2 <= 4'd0;
            digit3 <= 4'd0;
        end else begin
            // Increment ones digit
            if (digit0 == 4'd9) begin
                digit0 <= 4'd0;
                // Ones rolled over, increment tens
                if (digit1 == 4'd9) begin
                    digit1 <= 4'd0;
                    // Tens rolled over, increment hundreds
                    if (digit2 == 4'd9) begin
                        digit2 <= 4'd0;
                        // Hundreds rolled over, increment thousands
                        if (digit3 == 4'd9) begin
                            digit3 <= 4'd0; // Roll over after 9999
                        end else begin
                            digit3 <= digit3 + 4'd1;
                        end
                    end else begin
                        digit2 <= digit2 + 4'd1;
                    end
                end else begin
                    digit1 <= digit1 + 4'd1;
                end
            end else begin
                digit0 <= digit0 + 4'd1;
            end
        end
    end

endmodule