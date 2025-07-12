module alu(
    input  wire [31:0] a,
    input  wire [31:0] b,
    input  wire [5:0]  aluc,
    output wire [31:0] r,
    output wire        zero,
    output wire        carry,
    output wire        negative,
    output wire        overflow,
    output wire        flag
);

    // Opcode parameters
    localparam ADD  = 6'b100000;
    localparam ADDU = 6'b100001;
    localparam SUB  = 6'b100010;
    localparam SUBU = 6'b100011;
    localparam AND  = 6'b100100;
    localparam OR   = 6'b100101;
    localparam XOR  = 6'b100110;
    localparam NOR  = 6'b100111;
    localparam SLT  = 6'b101010;
    localparam SLTU = 6'b101011;
    localparam SLL  = 6'b000000;
    localparam SRL  = 6'b000010;
    localparam SRA  = 6'b000011;
    localparam SLLV = 6'b000100;
    localparam SRLV = 6'b000110;
    localparam SRAV = 6'b000111;
    localparam LUI  = 6'b001111;

    reg [31:0] res_reg;
    reg zero_reg;
    reg carry_reg;
    reg negative_reg;
    reg overflow_reg;
    reg flag_reg;

    // Signed operands for arithmetic and comparison
    wire signed [31:0] a_s = a;
    wire signed [31:0] b_s = b;

    // Shift amount for fixed shifts (from a[4:0]) or variable shifts (also a[4:0])
    wire [4:0] shamt = a[4:0];

    always @* begin
        // Default assignments
        res_reg = 32'b0;
        zero_reg = 1'b0;
        carry_reg = 1'b0;
        negative_reg = 1'b0;
        overflow_reg = 1'b0;
        flag_reg = 1'b0;

        case (aluc)
            ADD: begin
                {carry_reg, res_reg} = {1'b0, a} + {1'b0, b};
                // Overflow detection: signed addition overflow
                overflow_reg = (~a[31] & ~b[31] & res_reg[31]) | (a[31] & b[31] & ~res_reg[31]);
            end
            ADDU: begin
                {carry_reg, res_reg} = {1'b0, a} + {1'b0, b};
                overflow_reg = 1'b0;
            end
            SUB: begin
                {carry_reg, res_reg} = {1'b0, a} - {1'b0, b};
                // Overflow detection: signed subtraction overflow
                overflow_reg = (a[31] & ~b[31] & ~res_reg[31]) | (~a[31] & b[31] & res_reg[31]);
            end
            SUBU: begin
                {carry_reg, res_reg} = {1'b0, a} - {1'b0, b};
                overflow_reg = 1'b0;
            end
            AND:   res_reg = a & b;
            OR:    res_reg = a | b;
            XOR:   res_reg = a ^ b;
            NOR:   res_reg = ~(a | b);
            SLT: begin
                flag_reg = (a_s < b_s) ? 1'b1 : 1'b0;
                res_reg = flag_reg ? 32'd1 : 32'd0;
            end
            SLTU: begin
                flag_reg = (a < b) ? 1'b1 : 1'b0;
                res_reg = flag_reg ? 32'd1 : 32'd0;
            end
            SLL:   res_reg = b << shamt;
            SRL:   res_reg = b >> shamt;
            SRA:   res_reg = $signed(b) >>> shamt;
            SLLV:  res_reg = b << (a[4:0]);
            SRLV:  res_reg = b >> (a[4:0]);
            SRAV:  res_reg = $signed(b) >>> (a[4:0]);
            LUI:   res_reg = {a[15:0], 16'b0};
            default: begin
                res_reg = 32'bz;
                carry_reg = 1'b0;
                overflow_reg = 1'b0;
                flag_reg = 1'b0;
            end
        endcase

        // Negative flag: MSB of result
        negative_reg = res_reg[31];

        // Zero flag: result equals zero
        zero_reg = (res_reg == 32'b0);

        // For carry flag on SUB/SUBU: borrow detection - borrow = ~carry out for subtraction
        // already handled by carry_reg in subtraction above as MSB of extended subtraction
        // So invert carry_reg on subtraction to get correct carry meaning
        if (aluc == SUB || aluc == SUBU)
            carry_reg = ~carry_reg;
        // For other operations carry_reg is already set appropriately or zero
    end

    assign r = res_reg;
    assign zero = zero_reg;
    assign carry = carry_reg;
    assign negative = negative_reg;
    assign overflow = overflow_reg;
    assign flag = flag_reg;

endmodule