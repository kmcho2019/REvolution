module alu(
    input  wire [31:0] a,
    input  wire [31:0] b,
    input  wire [5:0]  aluc,
    output reg  [31:0] r,
    output wire        zero,
    output reg         carry,
    output reg         negative,
    output reg         overflow,
    output reg         flag
);

    // Opcode parameters
    parameter ADD  = 6'b100000;
    parameter ADDU = 6'b100001;
    parameter SUB  = 6'b100010;
    parameter SUBU = 6'b100011;
    parameter AND  = 6'b100100;
    parameter OR   = 6'b100101;
    parameter XOR  = 6'b100110;
    parameter NOR  = 6'b100111;
    parameter SLT  = 6'b101010;
    parameter SLTU = 6'b101011;
    parameter SLL  = 6'b000000;
    parameter SRL  = 6'b000010;
    parameter SRA  = 6'b000011;
    parameter SLLV = 6'b000100;
    parameter SRLV = 6'b000110;
    parameter SRAV = 6'b000111;
    parameter LUI  = 6'b001111;

    wire [4:0] shamt = a[4:0];  // shift amount used for both fixed and variable shifts
    reg [32:0] arith_ext;       // extended to detect carry/borrow
    reg [31:0] temp_r;
    reg temp_carry, temp_overflow, temp_flag;

    always @(*) begin
        // defaults
        temp_r = 32'd0;
        temp_carry = 1'b0;
        temp_overflow = 1'b0;
        temp_flag = 1'b0;

        case (aluc)
            ADD: begin
                arith_ext = {1'b0, a} + {1'b0, b};
                temp_r = arith_ext[31:0];
                temp_carry = arith_ext[32];
                // overflow for signed addition
                temp_overflow = (~a[31] & ~b[31] & temp_r[31]) | (a[31] & b[31] & ~temp_r[31]);
            end
            ADDU: begin
                arith_ext = {1'b0, a} + {1'b0, b};
                temp_r = arith_ext[31:0];
                temp_carry = arith_ext[32];
                temp_overflow = 1'b0;
            end
            SUB: begin
                arith_ext = {1'b0, a} - {1'b0, b};
                temp_r = arith_ext[31:0];
                temp_carry = arith_ext[32];
                // overflow for signed subtraction
                temp_overflow = (a[31] & ~b[31] & ~temp_r[31]) | (~a[31] & b[31] & temp_r[31]);
            end
            SUBU: begin
                arith_ext = {1'b0, a} - {1'b0, b};
                temp_r = arith_ext[31:0];
                temp_carry = arith_ext[32];
                temp_overflow = 1'b0;
            end
            AND:  temp_r = a & b;
            OR:   temp_r = a | b;
            XOR:  temp_r = a ^ b;
            NOR:  temp_r = ~(a | b);
            SLT: begin
                temp_flag = ($signed(a) < $signed(b)) ? 1'b1 : 1'b0;
                temp_r = temp_flag ? 32'd1 : 32'd0;
            end
            SLTU: begin
                temp_flag = (a < b) ? 1'b1 : 1'b0;
                temp_r = temp_flag ? 32'd1 : 32'd0;
            end
            SLL:  temp_r = b << shamt;
            SRL:  temp_r = b >> shamt;
            SRA:  temp_r = $signed(b) >>> shamt;
            SLLV: temp_r = b << shamt;
            SRLV: temp_r = b >> shamt;
            SRAV: temp_r = $signed(b) >>> shamt;
            LUI:  temp_r = {b[15:0],16'b0};
            default: begin
                temp_r = 32'd0;
                temp_carry = 1'b0;
                temp_overflow = 1'b0;
                temp_flag = 1'b0;
            end
        endcase

        r = temp_r;
        carry = temp_carry;
        overflow = temp_overflow;
        negative = temp_r[31];
        flag = ((aluc == SLT) || (aluc == SLTU)) ? temp_flag : 1'b0;
    end

    assign zero = (r == 32'd0);

endmodule