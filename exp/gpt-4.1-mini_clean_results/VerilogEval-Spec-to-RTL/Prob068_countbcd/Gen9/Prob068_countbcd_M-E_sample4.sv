module TopModule (
    input         clk,
    input         reset,
    output [2:0]  ena,
    output [15:0] q
);

    reg [15:0] bcd_counter;

    // Internal signals for corrected digits and carries
    wire [3:0] d0, d1, d2, d3;      // digits before correction
    wire [3:0] c0, c1, c2, c3;      // digits after correction
    wire       carry0, carry1, carry2; // carry from digit corrections

    // Assign each 4-bit digit from counter
    assign d0 = bcd_counter[3:0];
    assign d1 = bcd_counter[7:4];
    assign d2 = bcd_counter[11:8];
    assign d3 = bcd_counter[15:12];

    // BCD correction logic:
    // For each digit, if digit > 9, subtract 10 and generate carry to next digit.

    // Check if digit exceeds 9 (BCD invalid)
    wire d0_invalid = (d0 > 4'd9);
    wire d1_invalid = (d1 > 4'd9);
    wire d2_invalid = (d2 > 4'd9);
    wire d3_invalid = (d3 > 4'd9);

    // Correction and carry for ones digit
    assign carry0 = d0_invalid;
    assign c0 = carry0 ? (d0 - 4'd10) : d0;

    // Correction and carry for tens digit, add carry from ones
    wire [4:0] d1_plus_c0 = d1 + carry0;
    assign carry1 = (d1_plus_c0 > 5'd9);
    assign c1 = carry1 ? (d1_plus_c0 - 5'd10) [3:0] : d1_plus_c0[3:0];

    // Correction and carry for hundreds digit, add carry from tens
    wire [4:0] d2_plus_c1 = d2 + carry1;
    assign carry2 = (d2_plus_c1 > 5'd9);
    assign c2 = carry2 ? (d2_plus_c1 - 5'd10) [3:0] : d2_plus_c1[3:0];

    // Correction for thousands digit, add carry from hundreds
    wire [4:0] d3_plus_c2 = d3 + carry2;
    wire carry3 = (d3_plus_c2 > 5'd9);
    // If overflow at thousands digit, wrap around to 0 (0000)
    assign c3 = carry3 ? 4'd0 : d3_plus_c2[3:0];

    // Enable signals correspond to carry out from previous digit increments
    assign ena[0] = carry0; // enable tens digit increment
    assign ena[1] = carry1; // enable hundreds digit increment
    assign ena[2] = carry2; // enable thousands digit increment

    // Next value calculation and synchronous update
    always @(posedge clk) begin
        if (reset) begin
            bcd_counter <= 16'd0;
        end else begin
            // Increment entire counter by 1 binary
            // Then replace with corrected digits
            // This effectively implements BCD count with correction
            bcd_counter <= {c3, c2, c1, c0};
        end
    end

    assign q = bcd_counter;

endmodule