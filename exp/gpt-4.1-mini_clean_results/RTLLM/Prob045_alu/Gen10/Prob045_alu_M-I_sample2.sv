module alu(
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

// Opcodes as parameters
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

wire [4:0] shamt = a[4:0];

// Shared 33-bit adder/subtractor for ADD/ADDU/SUB/SUBU
reg [32:0] arith_res;
reg        arith_carry;
reg        arith_overflow;
reg [31:0] arith_result;
reg        arith_negative;

always @(*) begin
    case (aluc)
        ADD, ADDU: begin
            arith_res = {1'b0, a} + {1'b0, b};
            arith_result = arith_res[31:0];
            arith_carry = arith_res[32];
            // Overflow only for ADD (signed)
            if (aluc == ADD) begin
                arith_overflow = (~a[31] & ~b[31] & arith_result[31]) | (a[31] & b[31] & ~arith_result[31]);
            end else begin
                arith_overflow = 1'b0;
            end
            arith_negative = arith_result[31];
        end
        SUB, SUBU: begin
            arith_res = {1'b0, a} - {1'b0, b};
            arith_result = arith_res[31:0];
            arith_carry = arith_res[32];
            // Overflow only for SUB (signed)
            if (aluc == SUB) begin
                arith_overflow = (a[31] & ~b[31] & ~arith_result[31]) | (~a[31] & b[31] & arith_result[31]);
            end else begin
                arith_overflow = 1'b0;
            end
            arith_negative = arith_result[31];
        end
        default: begin
            arith_res = 33'd0;
            arith_result = 32'd0;
            arith_carry = 1'b0;
            arith_overflow = 1'b0;
            arith_negative = 1'b0;
        end
    endcase
end

// Combinational logic for other operations
wire [31:0] and_res  = a & b;
wire [31:0] or_res   = a | b;
wire [31:0] xor_res  = a ^ b;
wire [31:0] nor_res  = ~(a | b);
wire        slt_res  = ($signed(a) < $signed(b)) ? 1'b1 : 1'b0;
wire        sltu_res = (a < b) ? 1'b1 : 1'b0;
wire [31:0] sll_res  = b << shamt;
wire [31:0] srl_res  = b >> shamt;
wire [31:0] sra_res  = $signed(b) >>> shamt;
wire [31:0] sllv_res = b << a[4:0];
wire [31:0] srlv_res = b >> a[4:0];
wire [31:0] srav_res = $signed(b) >>> a[4:0];
// LUI: place a[15:0] in upper 16 bits, lower 16 bits zeroed
wire [31:0] lui_res  = {a[15:0], 16'b0} << 16; // equivalent to {a[15:0],16'b0} shifted left 16 bits

always @(*) begin
    // Default outputs
    r = 32'bz;
    zero = 1'b0;
    carry = 1'b0;
    negative = 1'b0;
    overflow = 1'b0;
    flag = 1'b0;

    case (aluc)
        ADD, ADDU, SUB, SUBU: begin
            r = arith_result;
            carry = arith_carry;
            overflow = arith_overflow;
            negative = arith_negative;
            zero = (arith_result == 32'b0);
            flag = 1'b0;
        end
        AND: begin
            r = and_res;
            carry = 1'b0;
            overflow = 1'b0;
            negative = r[31];
            zero = (r == 32'b0);
            flag = 1'b0;
        end
        OR: begin
            r = or_res;
            carry = 1'b0;
            overflow = 1'b0;
            negative = r[31];
            zero = (r == 32'b0);
            flag = 1'b0;
        end
        XOR: begin
            r = xor_res;
            carry = 1'b0;
            overflow = 1'b0;
            negative = r[31];
            zero = (r == 32'b0);
            flag = 1'b0;
        end
        NOR: begin
            r = nor_res;
            carry = 1'b0;
            overflow = 1'b0;
            negative = r[31];
            zero = (r == 32'b0);
            flag = 1'b0;
        end
        SLT: begin
            r = {31'b0, slt_res};
            carry = 1'b0;
            overflow = 1'b0;
            negative = 1'b0;
            zero = (r == 32'b0);
            flag = slt_res;
        end
        SLTU: begin
            r = {31'b0, sltu_res};
            carry = 1'b0;
            overflow = 1'b0;
            negative = 1'b0;
            zero = (r == 32'b0);
            flag = sltu_res;
        end
        SLL: begin
            r = sll_res;
            carry = 1'b0;
            overflow = 1'b0;
            negative = r[31];
            zero = (r == 32'b0);
            flag = 1'b0;
        end
        SRL: begin
            r = srl_res;
            carry = 1'b0;
            overflow = 1'b0;
            negative = r[31];
            zero = (r == 32'b0);
            flag = 1'b0;
        end
        SRA: begin
            r = sra_res;
            carry = 1'b0;
            overflow = 1'b0;
            negative = r[31];
            zero = (r == 32'b0);
            flag = 1'b0;
        end
        SLLV: begin
            r = sllv_res;
            carry = 1'b0;
            overflow = 1'b0;
            negative = r[31];
            zero = (r == 32'b0);
            flag = 1'b0;
        end
        SRLV: begin
            r = srlv_res;
            carry = 1'b0;
            overflow = 1'b0;
            negative = r[31];
            zero = (r == 32'b0);
            flag = 1'b0;
        end
        SRAV: begin
            r = srav_res;
            carry = 1'b0;
            overflow = 1'b0;
            negative = r[31];
            zero = (r == 32'b0);
            flag = 1'b0;
        end
        LUI: begin
            r = lui_res;
            carry = 1'b0;
            overflow = 1'b0;
            negative = r[31];
            zero = (r == 32'b0);
            flag = 1'b0;
        end
        default: begin
            r = 32'bz;
            carry = 1'b0;
            overflow = 1'b0;
            negative = 1'b0;
            zero = 1'b0;
            flag = 1'b0;
        end
    endcase
end

endmodule