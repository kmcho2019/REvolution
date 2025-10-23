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

    // Second combinational always block: division logic without remainder stages array
    always @(*) begin
        integer i;
        reg [7:0] remainder;
        reg [15:0] quotient_tmp;
        reg [8:0] rem_shifted;    // 9 bits: remainder << 1 + next bit

        remainder = 8'd0;
        quotient_tmp = 16'd0;

        for (i = 0; i < 16; i = i + 1) begin
            rem_shifted = {remainder, a_reg[15 - i]};
            if (rem_shifted >= {1'b0, b_reg}) begin
                remainder = rem_shifted - {1'b0, b_reg};
                quotient_tmp[15 - i] = 1'b1;
            end else begin
                remainder = rem_shifted[7:0];
                quotient_tmp[15 - i] = 1'b0;
            end
        end

        result = quotient_tmp;
        odd = {8'd0, remainder};
    end

endmodule