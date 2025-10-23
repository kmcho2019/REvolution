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

    // Second combinational always block: combinational division logic
    always @(*) begin
        integer i;
        reg [7:0] remainder;       // 8-bit remainder register
        reg [15:0] quotient_tmp;   // temporary quotient register

        remainder = 8'd0;
        quotient_tmp = 16'd0;

        for (i = 15; i >= 0; i = i - 1) begin
            // Shift remainder left by 1 and bring next dividend bit
            remainder = {remainder[6:0], a_reg[i]};

            // Compare and subtract if possible
            if (remainder >= b_reg) begin
                remainder = remainder - b_reg;
                quotient_tmp[i] = 1'b1;
            end else begin
                quotient_tmp[i] = 1'b0;
            end
        end

        result = quotient_tmp;
        odd = {8'd0, remainder}; // upper 8 bits zero, lower 8 bits remainder
    end

endmodule