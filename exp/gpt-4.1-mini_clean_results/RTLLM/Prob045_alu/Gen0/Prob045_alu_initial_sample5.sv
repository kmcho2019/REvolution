module alu(
    input  [31:0] a,
    input  [31:0] b,
    input  [5:0]  aluc,
    output reg [31:0] r,
    output        zero,
    output        carry,
    output        negative,
    output        overflow,
    output reg    flag
);

    parameter ADD   = 6'b100000;
    parameter ADDU  = 6'b100001;
    parameter SUB   = 6'b100010;
    parameter SUBU  = 6'b100011;
    parameter AND   = 6'b100100;
    parameter OR    = 6'b100101;
    parameter XOR   = 6'b100110;
    parameter NOR   = 6'b100111;
    parameter SLT   = 6'b101010;
    parameter SLTU  = 6'b101011;
    parameter SLL   = 6'b000000;
    parameter SRL   = 6'b000010;
    parameter SRA   = 6'b000011;
    parameter SLLV  = 6'b000100;
    parameter SRLV  = 6'b000110;
    parameter SRAV  = 6'b000111;
    parameter LUI   = 6'b001111;

    wire signed [31:0] a_signed = a;
    wire signed [31:0] b_signed = b;

    reg [32:0] sum; // 33 bits to detect carry for addition/subtraction

    always @(*) begin
        // Default outputs
        r = 32'bz;
        flag = 1'bz;

        case(aluc)
            ADD: begin
                sum = {a[31],a} + {b[31],b};
                r = sum[31:0];
                flag = 1'bz;
            end
            ADDU: begin
                sum = {1'b0,a} + {1'b0,b};
                r = sum[31:0];
                flag = 1'bz;
            end
            SUB: begin
                sum = {a[31],a} - {b[31],b};
                r = sum[31:0];
                flag = 1'bz;
            end
            SUBU: begin
                sum = {1'b0,a} - {1'b0,b};
                r = sum[31:0];
                flag = 1'bz;
            end
            AND: begin
                r = a & b;
                flag = 1'bz;
            end
            OR: begin
                r = a | b;
                flag = 1'bz;
            end
            XOR: begin
                r = a ^ b;
                flag = 1'bz;
            end
            NOR: begin
                r = ~(a | b);
                flag = 1'bz;
            end
            SLT: begin
                // signed comparison
                flag = (a_signed < b_signed) ? 1'b1 : 1'b0;
                r = {31'b0, flag};
            end
            SLTU: begin
                // unsigned comparison
                flag = (a < b) ? 1'b1 : 1'b0;
                r = {31'b0, flag};
            end
            SLL: begin
                r = b << a[4:0];
                flag = 1'bz;
            end
            SRL: begin
                r = b >> a[4:0];
                flag = 1'bz;
            end
            SRA: begin
                r = $signed(b) >>> a[4:0];
                flag = 1'bz;
            end
            SLLV: begin
                r = b << a[4:0];
                flag = 1'bz;
            end
            SRLV: begin
                r = b >> a[4:0];
                flag = 1'bz;
            end
            SRAV: begin
                r = $signed(b) >>> a[4:0];
                flag = 1'bz;
            end
            LUI: begin
                // Load upper immediate: upper 16 bits from b, lower 16 bits zero
                r = {b[15:0], 16'b0};
                flag = 1'bz;
            end
            default: begin
                r = 32'bz;
                flag = 1'bz;
            end
        endcase
    end

    // Flags calculation

    // zero is 1 if r == 0
    assign zero = (r == 32'b0);

    // negative is MSB of r
    assign negative = r[31];

    // carry and overflow only valid for arithmetic operations ADD, ADDU, SUB, SUBU
    // carry for unsigned addition/subtraction from bit 32
    wire carry_add  = (aluc == ADDU) && sum[32];
    wire carry_sub  = (aluc == SUBU) && ~sum[32]; // borrow detection for subtraction unsigned: borrow if result > a (unsigned) -> if no borrow, sum[32] = 1 else 0, inverted here
    wire carry_arith = carry_add | carry_sub;

    assign carry = (aluc == ADDU || aluc == SUBU) ? carry_arith : 1'b0;

    // Overflow detection for signed addition and subtraction
    // For ADD: overflow if sign of a == sign of b, but sign of result != sign of a
    wire overflow_add = (aluc == ADD) && ((a[31] == b[31]) && (r[31] != a[31]));
    // For SUB: overflow if sign of a != sign of b, and sign of result != sign of a
    wire overflow_sub = (aluc == SUB) && ((a[31] != b[31]) && (r[31] != a[31]));

    assign overflow = overflow_add | overflow_sub;

endmodule