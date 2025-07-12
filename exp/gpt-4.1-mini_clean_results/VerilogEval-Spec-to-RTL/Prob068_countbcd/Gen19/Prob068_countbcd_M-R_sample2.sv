module TopModule (
    input         clk,
    input         reset,
    output [2:0]  ena,
    output [15:0] q
);

    reg [15:0] bin_count;  // 16-bit binary counter (0 to 9999)

    // Synchronous binary counter with reset
    always @(posedge clk) begin
        if (reset) begin
            bin_count <= 16'd0;
        end else begin
            if (bin_count == 16'd9999)
                bin_count <= 16'd0;
            else
                bin_count <= bin_count + 16'd1;
        end
    end

    // BCD conversion using double dabble (shift and add-3) algorithm
    reg [3:0] bcd [3:0]; // BCD digits: [3] thousands, [2] hundreds, [1] tens, [0] ones
    integer i;

    always @* begin
        // Initialize BCD digits
        bcd[3] = 4'd0;
        bcd[2] = 4'd0;
        bcd[1] = 4'd0;
        bcd[0] = 4'd0;
        // Double dabble: shift in each bit of bin_count from MSB to LSB
        for (i = 15; i >= 0; i = i - 1) begin
            // Add 3 if digit >= 5 before shifting
            if (bcd[3] >= 5) bcd[3] = bcd[3] + 3;
            if (bcd[2] >= 5) bcd[2] = bcd[2] + 3;
            if (bcd[1] >= 5) bcd[1] = bcd[1] + 3;
            if (bcd[0] >= 5) bcd[0] = bcd[0] + 3;
            // Shift left all digits by 1
            bcd[3] = {bcd[3][2:0], bcd[2][3]};
            bcd[2] = {bcd[2][2:0], bcd[1][3]};
            bcd[1] = {bcd[1][2:0], bcd[0][3]};
            bcd[0] = {bcd[0][2:0], bin_count[i]};
        end
    end

    // Assign output q as concatenated BCD digits
    assign q = {bcd[3], bcd[2], bcd[1], bcd[0]};

    // Enable signals: when lower digit is 9, next digit increments
    assign ena[0] = (bcd[0] == 4'd9);
    assign ena[1] = (bcd[1] == 4'd9) & ena[0];
    assign ena[2] = (bcd[2] == 4'd9) & ena[1];

endmodule