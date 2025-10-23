module alu (
    input  wire [31:0] a,
    input  wire [31:0] b,
    input  wire [5:0]  aluc,
    output reg  [31:0] r,
    output reg         zero,
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

// Internal wires
wire signed [31:0] a_s = a;
wire signed [31:0] b_s = b;
wire [4:0] shamt = a[4:0];

// Internal signals for arithmetic results
reg [32:0] add_res;
reg [32:0] sub_res;
reg signed [31:0] sub_signed_res;

// Helper task to compute overflow for addition
function overflow_add;
    input [31:0] op1, op2;
    input [31:0] res32;
    begin
        // Overflow when signs of operands equal and sign of result differs
        overflow_add = (~op1[31] & ~op2[31] & res32[31]) | (op1[31] & op2[31] & ~res32[31]);
    end
endfunction

// Helper task to compute overflow for subtraction
function overflow_sub;
    input [31:0] op1, op2;
    input [31:0] res32;
    begin
        // Overflow when op1 and op2 have different signs and result sign differs from op1
        overflow_sub = (op1[31] & ~op2[31] & ~res32[31]) | (~op1[31] & op2[31] & res32[31]);
    end
endfunction

always @* begin
    // Default assignments
    r        = 32'bz;  // High-impedance default as per spec
    zero     = 1'b0;
    carry    = 1'b0;
    negative = 1'b0;
    overflow = 1'b0;
    flag     = 1'bz;

    case (aluc)
        // ADD signed
        ADD: begin
            add_res = {1'b0, a} + {1'b0, b};
            r      = add_res[31:0];
            carry  = add_res[32];
            overflow = overflow_add(a, b, r);
            zero   = (r == 0);
            negative = r[31];
            flag   = 1'bz;
        end

        // ADD unsigned
        ADDU: begin
            add_res = {1'b0, a} + {1'b0, b};
            r      = add_res[31:0];
            carry  = add_res[32];
            overflow = 1'b0;
            zero   = (r == 0);
            negative = r[31];
            flag   = 1'bz;
        end

        // SUB signed
        SUB: begin
            sub_res = {1'b0, a} - {1'b0, b};
            r       = sub_res[31:0];
            carry   = sub_res[32]; // borrow bit inverted: high if no borrow
            overflow = overflow_sub(a, b, r);
            zero    = (r == 0);
            negative = r[31];
            flag    = 1'bz;
        end

        // SUB unsigned
        SUBU: begin
            sub_res = {1'b0, a} - {1'b0, b};
            r       = sub_res[31:0];
            carry   = sub_res[32];
            overflow = 1'b0;
            zero    = (r == 0);
            negative = r[31];
            flag    = 1'bz;
        end

        // Logical AND
        AND: begin
            r = a & b;
            zero = (r == 0);
            negative = r[31];
            carry = 1'b0;
            overflow = 1'b0;
            flag = 1'bz;
        end

        // Logical OR
        OR: begin
            r = a | b;
            zero = (r == 0);
            negative = r[31];
            carry = 1'b0;
            overflow = 1'b0;
            flag = 1'bz;
        end

        // Logical XOR
        XOR: begin
            r = a ^ b;
            zero = (r == 0);
            negative = r[31];
            carry = 1'b0;
            overflow = 1'b0;
            flag = 1'bz;
        end

        // Logical NOR
        NOR: begin
            r = ~(a | b);
            zero = (r == 0);
            negative = r[31];
            carry = 1'b0;
            overflow = 1'b0;
            flag = 1'bz;
        end

        // SLT signed: set flag and r accordingly
        SLT: begin
            flag = (a_s < b_s) ? 1'b1 : 1'b0;
            r = {31'b0, flag};
            zero = (r == 0);
            negative = r[31];
            carry = 1'b0;
            overflow = 1'b0;
        end

        // SLTU unsigned: set flag and r accordingly
        SLTU: begin
            flag = (a < b) ? 1'b1 : 1'b0;
            r = {31'b0, flag};
            zero = (r == 0);
            negative = r[31];
            carry = 1'b0;
            overflow = 1'b0;
        end

        // Shift left logical by immediate
        SLL: begin
            r = b << shamt;
            zero = (r == 0);
            negative = r[31];
            carry = 1'b0;
            overflow = 1'b0;
            flag = 1'bz;
        end

        // Shift right logical by immediate
        SRL: begin
            r = b >> shamt;
            zero = (r == 0);
            negative = r[31];
            carry = 1'b0;
            overflow = 1'b0;
            flag = 1'bz;
        end

        // Shift right arithmetic by immediate
        SRA: begin
            r = $signed(b) >>> shamt;
            zero = (r == 0);
            negative = r[31];
            carry = 1'b0;
            overflow = 1'b0;
            flag = 1'bz;
        end

        // Shift left logical by variable amount (from a[4:0])
        SLLV: begin
            r = b << a[4:0];
            zero = (r == 0);
            negative = r[31];
            carry = 1'b0;
            overflow = 1'b0;
            flag = 1'bz;
        end

        // Shift right logical by variable amount (from a[4:0])
        SRLV: begin
            r = b >> a[4:0];
            zero = (r == 0);
            negative = r[31];
            carry = 1'b0;
            overflow = 1'b0;
            flag = 1'bz;
        end

        // Shift right arithmetic by variable amount (from a[4:0])
        SRAV: begin
            r = $signed(b) >>> a[4:0];
            zero = (r == 0);
            negative = r[31];
            carry = 1'b0;
            overflow = 1'b0;
            flag = 1'bz;
        end

        // Load upper immediate: move a[15:0] to upper half, zeros lower
        LUI: begin
            r = {a[15:0], 16'b0};
            zero = (r == 0);
            negative = r[31];
            carry = 1'b0;
            overflow = 1'b0;
            flag = 1'bz;
        end

        // Default: output high impedance
        default: begin
            r = 32'bz;
            zero = 1'b0;
            carry = 1'b0;
            negative = 1'b0;
            overflow = 1'b0;
            flag = 1'bz;
        end
    endcase
end

endmodule