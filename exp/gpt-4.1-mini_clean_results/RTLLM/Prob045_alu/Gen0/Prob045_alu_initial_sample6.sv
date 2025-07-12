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

// Define opcodes as parameters
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

// Internal signals
reg [32:0] add_sub_result;  // 33-bit to detect carry out for ADD/SUB
reg [31:0] sll_res, srl_res, sra_res;
wire [4:0] shamt;           // shift amount
wire signed [31:0] a_signed = $signed(a);
wire signed [31:0] b_signed = $signed(b);
reg signed [31:0] res_signed;
reg [31:0] res_unsigned;

assign shamt = a[4:0];

// zero flag is high when result is zero
assign zero = (r == 32'b0);

always @* begin
    // default assignments
    r = 32'bz;
    carry = 1'b0;
    negative = 1'b0;
    overflow = 1'b0;
    flag = 1'bz; // default high impedance for non SLT/SLTU
    
    case(aluc)
        ADD: begin
            add_sub_result = {1'b0, a} + {1'b0, b};
            r = add_sub_result[31:0];
            carry = add_sub_result[32];
            // signed overflow detection
            res_signed = $signed(a) + $signed(b);
            overflow = ((a[31] == b[31]) && (r[31] != a[31]));
            negative = r[31];
            flag = 1'bz;
        end
        ADDU: begin
            add_sub_result = {1'b0, a} + {1'b0, b};
            r = add_sub_result[31:0];
            carry = add_sub_result[32];
            overflow = 1'b0;
            negative = r[31];
            flag = 1'bz;
        end
        SUB: begin
            add_sub_result = {1'b0, a} - {1'b0, b};
            r = add_sub_result[31:0];
            carry = (a >= b) ? 1'b1 : 1'b0; // borrow inverted is carry
            // signed overflow detection for subtraction
            overflow = ((a[31] != b[31]) && (r[31] != a[31]));
            negative = r[31];
            flag = 1'bz;
        end
        SUBU: begin
            add_sub_result = {1'b0, a} - {1'b0, b};
            r = add_sub_result[31:0];
            carry = (a >= b) ? 1'b1 : 1'b0;
            overflow = 1'b0;
            negative = r[31];
            flag = 1'bz;
        end
        AND: begin
            r = a & b;
            carry = 1'b0;
            overflow = 1'b0;
            negative = r[31];
            flag = 1'bz;
        end
        OR: begin
            r = a | b;
            carry = 1'b0;
            overflow = 1'b0;
            negative = r[31];
            flag = 1'bz;
        end
        XOR: begin
            r = a ^ b;
            carry = 1'b0;
            overflow = 1'b0;
            negative = r[31];
            flag = 1'bz;
        end
        NOR: begin
            r = ~(a | b);
            carry = 1'b0;
            overflow = 1'b0;
            negative = r[31];
            flag = 1'bz;
        end
        SLT: begin
            // Set on less than (signed)
            flag = (a_signed < b_signed) ? 1'b1 : 1'b0;
            r = {31'b0, flag};
            carry = 1'b0;
            overflow = 1'b0;
            negative = 1'b0;
        end
        SLTU: begin
            // Set on less than (unsigned)
            flag = (a < b) ? 1'b1 : 1'b0;
            r = {31'b0, flag};
            carry = 1'b0;
            overflow = 1'b0;
            negative = 1'b0;
        end
        SLL: begin
            // shift b left by shamt (from a[4:0])
            r = b << shamt;
            carry = 1'b0;
            overflow = 1'b0;
            negative = r[31];
            flag = 1'bz;
        end
        SRL: begin
            r = b >> shamt;
            carry = 1'b0;
            overflow = 1'b0;
            negative = r[31];
            flag = 1'bz;
        end
        SRA: begin
            // Arithmetic right shift preserves sign bit
            r = $signed(b) >>> shamt;
            carry = 1'b0;
            overflow = 1'b0;
            negative = r[31];
            flag = 1'bz;
        end
        SLLV: begin
            // shift b left by amount in a[4:0]
            r = b << (a[4:0]);
            carry = 1'b0;
            overflow = 1'b0;
            negative = r[31];
            flag = 1'bz;
        end
        SRLV: begin
            r = b >> (a[4:0]);
            carry = 1'b0;
            overflow = 1'b0;
            negative = r[31];
            flag = 1'bz;
        end
        SRAV: begin
            r = $signed(b) >>> (a[4:0]);
            carry = 1'b0;
            overflow = 1'b0;
            negative = r[31];
            flag = 1'bz;
        end
        LUI: begin
            // Load upper immediate: b ignored, upper 16 bits = a[15:0], lower 16 bits zero
            r = {a[15:0], 16'b0};
            carry = 1'b0;
            overflow = 1'b0;
            negative = r[31];
            flag = 1'bz;
        end
        default: begin
            r = 32'bz;
            carry = 1'b0;
            overflow = 1'b0;
            negative = 1'b0;
            flag = 1'bz;
        end
    endcase
end

endmodule