module div_16bit (
    input  wire [15:0] A,       // Dividend
    input  wire [7:0]  B,       // Divisor
    output reg  [15:0] result,  // Quotient
    output reg  [15:0] odd      // Remainder (lower 8 bits valid)
);

    reg [15:0] a_reg;
    reg [7:0]  b_reg;

    // First combinational always block: latch inputs
    always @(*) begin
        a_reg = A;
        b_reg = B;
    end

    // Second combinational always block: division logic with 8-bit remainder stages
    always @(*) begin
        integer i;
        reg [7:0] rem_stages [0:16];  // 8-bit remainder stages (0 to 16)
        reg [15:0] quotient_tmp;

        rem_stages[0] = 8'd0;

        for (i = 0; i < 16; i = i + 1) begin
            reg [8:0] rem_shifted;    // 9 bits needed to shift remainder left by 1 and bring in next bit
            reg [8:0] rem_sub;

            rem_shifted = {rem_stages[i], a_reg[15 - i]};  // 8 bits remainder << 1 + next dividend bit
            rem_sub = rem_shifted - {1'b0, b_reg};

            if (rem_shifted >= {1'b0, b_reg}) begin
                rem_stages[i + 1] = rem_sub[7:0];
                quotient_tmp[15 - i] = 1'b1;
            end else begin
                rem_stages[i + 1] = rem_shifted[7:0];
                quotient_tmp[15 - i] = 1'b0;
            end
        end

        result = quotient_tmp;
        odd = {8'd0, rem_stages[16]};
    end

endmodule