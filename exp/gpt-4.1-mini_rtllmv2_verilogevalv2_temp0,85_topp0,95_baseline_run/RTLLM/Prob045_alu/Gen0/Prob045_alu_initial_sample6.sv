module alu (
    input  wire [31:0] a,
    input  wire [31:0] b,
    input  wire [5:0]  aluc,
    output reg  [31:0] r,
    output wire        zero,
    output reg         carry,
    output wire        negative,
    output reg         overflow,
    output reg         flag
);
    // Define parameters for opcodes
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

    reg [32:0] add_sub_res; // 33-bit to capture carry out
    reg signed [31:0] a_signed, b_signed;
    reg [4:0] shamt;

    always @* begin
        // default assignments
        r = 32'bz;
        carry = 1'b0;
        overflow = 1'b0;
        flag = 1'bz;

        a_signed = $signed(a);
        b_signed = $signed(b);
        shamt = a[4:0];

        case (aluc)
            ADD: begin
                add_sub_res = {1'b0, a} + {1'b0, b};
                r = add_sub_res[31:0];
                carry = add_sub_res[32];
                // Overflow detection for signed addition
                overflow = (~a[31] & ~b[31] & r[31]) | (a[31] & b[31] & ~r[31]);
                flag = 1'bz;
            end

            ADDU: begin
                add_sub_res = {1'b0, a} + {1'b0, b};
                r = add_sub_res[31:0];
                carry = add_sub_res[32];
                overflow = 1'b0; // No overflow for unsigned add
                flag = 1'bz;
            end

            SUB: begin
                add_sub_res = {1'b0, a} - {1'b0, b};
                r = add_sub_res[31:0];
                carry = ~add_sub_res[32]; // Borrow is ~carry in subtraction
                // Overflow detection for signed subtraction
                overflow = (a[31] & ~b[31] & ~r[31]) | (~a[31] & b[31] & r[31]);
                flag = 1'bz;
            end

            SUBU: begin
                add_sub_res = {1'b0, a} - {1'b0, b};
                r = add_sub_res[31:0];
                carry = ~add_sub_res[32]; // borrow
                overflow = 1'b0;
                flag = 1'bz;
            end

            AND: begin
                r = a & b;
                carry = 1'b0;
                overflow = 1'b0;
                flag = 1'bz;
            end

            OR: begin
                r = a | b;
                carry = 1'b0;
                overflow = 1'b0;
                flag = 1'bz;
            end

            XOR: begin
                r = a ^ b;
                carry = 1'b0;
                overflow = 1'b0;
                flag = 1'bz;
            end

            NOR: begin
                r = ~(a | b);
                carry = 1'b0;
                overflow = 1'b0;
                flag = 1'bz;
            end

            SLT: begin
                // signed comparison a < b
                r = (a_signed < b_signed) ? 32'd1 : 32'd0;
                flag = r[0];
                carry = 1'b0;
                overflow = 1'b0;
            end

            SLTU: begin
                // unsigned comparison a < b
                r = (a < b) ? 32'd1 : 32'd0;
                flag = r[0];
                carry = 1'b0;
                overflow = 1'b0;
            end

            SLL: begin
                r = b << a[4:0];
                carry = 1'b0;
                overflow = 1'b0;
                flag = 1'bz;
            end

            SRL: begin
                r = b >> a[4:0];
                carry = 1'b0;
                overflow = 1'b0;
                flag = 1'bz;
            end

            SRA: begin
                r = $signed(b) >>> a[4:0];
                carry = 1'b0;
                overflow = 1'b0;
                flag = 1'bz;
            end

            SLLV: begin
                r = b << shamt;
                carry = 1'b0;
                overflow = 1'b0;
                flag = 1'bz;
            end

            SRLV: begin
                r = b >> shamt;
                carry = 1'b0;
                overflow = 1'b0;
                flag = 1'bz;
            end

            SRAV: begin
                r = $signed(b) >>> shamt;
                carry = 1'b0;
                overflow = 1'b0;
                flag = 1'bz;
            end

            LUI: begin
                // Load upper immediate: a[15:0] << 16
                r = {a[15:0], 16'b0};
                carry = 1'b0;
                overflow = 1'b0;
                flag = 1'bz;
            end

            default: begin
                r = 32'bz;
                carry = 1'b0;
                overflow = 1'b0;
                flag = 1'bz;
            end
        endcase
    end

    assign zero = (r == 32'b0) ? 1'b1 : 1'b0;
    assign negative = r[31];

endmodule