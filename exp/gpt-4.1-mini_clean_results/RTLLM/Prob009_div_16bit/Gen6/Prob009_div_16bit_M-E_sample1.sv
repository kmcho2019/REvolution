module div_16bit (
    input  wire [15:0] A,      // 16-bit dividend
    input  wire [7:0]  B,      // 8-bit divisor
    output reg  [15:0] result, // 16-bit quotient
    output reg  [15:0] odd     // 16-bit remainder (zero-extended)
);

    reg [15:0] a_reg;
    reg [7:0]  b_reg;

    reg [7:0]  tmp_rem;    // 8-bit temporary remainder register
    reg [15:0] quotient;   // 16-bit quotient register

    integer i;

    // Always block 1: latch inputs into registers (combinational)
    always @(*) begin
        a_reg = A;
        b_reg = B;
    end

    // Always block 2: combinational division logic using shift-subtract approach
    always @(*) begin
        tmp_rem = 8'b0;
        quotient = 16'b0;

        // Process bits from MSB to LSB
        for (i = 15; i >= 0; i = i - 1) begin
            // Shift left remainder by 1 and bring in current bit of dividend
            tmp_rem = {tmp_rem[6:0], a_reg[i]};

            // Compare remainder with divisor
            if (tmp_rem >= b_reg) begin
                tmp_rem = tmp_rem - b_reg;
                quotient[i] = 1'b1; // Set quotient bit
            end else begin
                quotient[i] = 1'b0;
            end
        end

        result = quotient;
        odd = {8'b0, tmp_rem}; // Zero-extend remainder to 16 bits
    end

endmodule