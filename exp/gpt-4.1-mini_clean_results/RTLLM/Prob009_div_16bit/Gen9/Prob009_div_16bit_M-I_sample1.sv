module div_16bit (
    input  wire [15:0] A,       // Dividend
    input  wire [7:0]  B,       // Divisor
    output reg  [15:0] result,  // Quotient
    output reg  [15:0] odd      // Remainder (lower 8 bits valid)
);

    reg [15:0] a_reg;
    reg [7:0]  b_reg;

    // Register inputs in first always block (combinational assignment to regs)
    always @(*) begin
        a_reg = A;
        b_reg = B;
    end

    // Second combinational always block performs division using internal variables
    always @(*) begin
        integer i;
        reg [8:0] rem;           // 9-bit remainder register: 8 bits divisor + 1 guard bit
        reg [15:0] quot_tmp;

        rem = 9'd0;
        quot_tmp = 16'd0;

        for (i = 15; i >= 0; i = i - 1) begin
            // Shift remainder left by 1 and bring in next dividend bit
            rem = {rem[7:0], a_reg[i]};

            // Compare remainder with divisor and subtract if possible
            if (rem >= {1'b0, b_reg}) begin
                rem = rem - {1'b0, b_reg};
                quot_tmp[i] = 1'b1;
            end else begin
                quot_tmp[i] = 1'b0;
            end
        end

        // Assign output signals
        result = quot_tmp;
        // The remainder is lower 8 bits of rem padded to 16 bits in upper bits zero
        odd = {8'd0, rem[7:0]};
    end

endmodule