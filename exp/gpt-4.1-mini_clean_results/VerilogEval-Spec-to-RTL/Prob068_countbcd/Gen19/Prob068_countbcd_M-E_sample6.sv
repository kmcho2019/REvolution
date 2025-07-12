module TopModule (
    input        clk,
    input        reset,
    output reg [2:0] ena,
    output reg [15:0] q
);
    reg [13:0] bin_count;  // Enough bits to count up to 9999 (max 14 bits needed)

    // Binary counter from 0 to 9999
    always @(posedge clk) begin
        if (reset) begin
            bin_count <= 14'd0;
        end else begin
            if (bin_count == 14'd9999)
                bin_count <= 14'd0;
            else
                bin_count <= bin_count + 14'd1;
        end
    end

    // BCD Conversion using Double Dabble (shift-add-3) algorithm
    // The conversion happens combinationally each clock cycle after increment
    reg [3:0] digits [3:0]; // digits[0] = ones, digits[1] = tens, etc.

    integer i;
    reg [27:0] shift_reg; // 14 bits binary + 14 bits of conversion buffer approx

    always @(*) begin
        // Initialize shift register with binary count at right, zeros at left
        // Use 28 bits: upper 14 bits for BCD digits, lower 14 bits binary count
        shift_reg = 28'd0;
        shift_reg[13:0] = bin_count;

        // Perform 14 shifts (equal to bit-width of bin_count)
        for (i = 13; i >= 0; i = i -1) begin
            // Check BCD digits and add 3 if >= 5
            if (shift_reg[27:24] >= 5)
                shift_reg[27:24] = shift_reg[27:24] + 4'd3;
            if (shift_reg[23:20] >= 5)
                shift_reg[23:20] = shift_reg[23:20] + 4'd3;
            if (shift_reg[19:16] >= 5)
                shift_reg[19:16] = shift_reg[19:16] + 4'd3;
            if (shift_reg[15:12] >= 5)
                shift_reg[15:12] = shift_reg[15:12] + 4'd3;

            // Shift left by 1
            shift_reg = shift_reg << 1;
        end

        // Extract digits from shifted register
        digits[3] = shift_reg[27:24]; // thousands
        digits[2] = shift_reg[23:20]; // hundreds
        digits[1] = shift_reg[19:16]; // tens
        digits[0] = shift_reg[15:12]; // ones
    end

    // Assign output q as concatenation of BCD digits
    always @(posedge clk) begin
        if (reset) begin
            q <= 16'd0;
            ena <= 3'd0;
        end else begin
            q <= {digits[3], digits[2], digits[1], digits[0]};
            // Generate ena signals:
            // ena[0] = enable tens digit: ones digit about to rollover (9)
            ena[0] <= (digits[0] == 4'd9);
            // ena[1] = enable hundreds digit: ones and tens digits about to rollover
            ena[1] <= (digits[0] == 4'd9) && (digits[1] == 4'd9);
            // ena[2] = enable thousands digit: ones, tens, hundreds digits about to rollover
            ena[2] <= (digits[0] == 4'd9) && (digits[1] == 4'd9) && (digits[2] == 4'd9);
        end
    end

endmodule