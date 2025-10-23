module TopModule (
    input         clk,
    input         reset,
    output [2:0]  ena,
    output [15:0] q
);
    reg [13:0] bin_count; // 14 bits suffice for count up to 9999 decimal (max 10000 requires 14 bits)
    reg [15:0] prev_bcd;  // Previous BCD value to detect increments

    // Function: Binary to BCD conversion (for 0 to 9999)
    // Implements Double Dabble algorithm combinationally
    function [15:0] bin2bcd;
        input [13:0] binary_in;
        integer i;
        reg [27:0] shift_reg; // 14 bits input + 4 digits x4bits = 16 bits plus extra for shifting
    begin
        shift_reg = 28'd0;
        shift_reg[13:0] = binary_in;

        for (i = 0; i < 14; i = i + 1) begin
            // Check each BCD digit (4 bits) and add 3 if >=5 before shift
            if (shift_reg[27:24] >= 5) shift_reg[27:24] = shift_reg[27:24] + 3;
            if (shift_reg[23:20] >= 5) shift_reg[23:20] = shift_reg[23:20] + 3;
            if (shift_reg[19:16] >= 5) shift_reg[19:16] = shift_reg[19:16] + 3;
            if (shift_reg[15:12] >= 5) shift_reg[15:12] = shift_reg[15:12] + 3;

            // Shift left by 1 bit
            shift_reg = shift_reg << 1;
        end

        // Return concatenated BCD digits: thousands, hundreds, tens, ones
        bin2bcd = {shift_reg[27:24], shift_reg[23:20], shift_reg[19:16], shift_reg[15:12]};
    end
    endfunction

    wire [15:0] bcd_out = bin2bcd(bin_count);

    // Enable signals: indicate when digit increments (compare current and previous digit)
    // ena[0] for ones digit is not needed per spec; only for digits [3:1]
    wire ena_thousands = (prev_bcd[15:12] != bcd_out[15:12]);
    wire ena_hundreds  = (prev_bcd[11:8]  != bcd_out[11:8]);
    wire ena_tens      = (prev_bcd[7:4]   != bcd_out[7:4]);

    assign ena = {ena_thousands, ena_hundreds, ena_tens};

    // Output BCD digits
    assign q = bcd_out;

    // Sequential logic for binary counter and previous BCD storage
    always @(posedge clk) begin
        if (reset) begin
            bin_count <= 14'd0;
            prev_bcd  <= 16'd0;
        end else begin
            if (bin_count == 14'd9999)
                bin_count <= 14'd0;
            else
                bin_count <= bin_count + 1'b1;

            prev_bcd <= bcd_out;
        end
    end

endmodule