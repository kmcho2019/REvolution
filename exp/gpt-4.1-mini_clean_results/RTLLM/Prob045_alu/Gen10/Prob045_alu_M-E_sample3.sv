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

wire [4:0] shamt_fixed = a[4:0];
wire [4:0] shamt_var = a[4:0];

// Arithmetic extended operands for carry/borrow detection
wire [32:0] a_ext = {1'b0, a};
wire [32:0] b_ext = {1'b0, b};

// Signed versions for overflow and comparisons
wire signed [31:0] a_s = $signed(a);
wire signed [31:0] b_s = $signed(b);

// Arithmetic operations
reg [32:0] add_res;
reg [32:0] sub_res;

// Arithmetic overflow detection signals
wire add_overflow;
wire sub_overflow;

// Flag for SLT/SLTU
reg slt_flag;
reg sltu_flag;

// Shift outputs
reg [31:0] shift_res;

// Logical outputs
reg [31:0] logic_res;

// Intermediate result and flags
reg [31:0] alu_res;
reg alu_carry;
reg alu_overflow;
reg alu_flag;

// Shift implementations
function [31:0] shl;
    input [31:0] val;
    input [4:0]  amt;
    begin
        shl = val << amt;
    end
endfunction

function [31:0] shr_logical;
    input [31:0] val;
    input [4:0]  amt;
    begin
        shr_logical = val >> amt;
    end
endfunction

function [31:0] shr_arith;
    input signed [31:0] val;
    input [4:0]  amt;
    begin
        shr_arith = val >>> amt;
    end
endfunction

// Arithmetic
always @* begin
    add_res = a_ext + b_ext;
    sub_res = a_ext - b_ext;
end

assign add_overflow = (~a[31] & ~b[31] & add_res[31]) | (a[31] & b[31] & ~add_res[31]);
assign sub_overflow = (a[31] & ~b[31] & ~sub_res[31]) | (~a[31] & b[31] & sub_res[31]);

// Logical
always @* begin
    logic_res = 32'b0;
    case (aluc)
        AND: logic_res = a & b;
        OR:  logic_res = a | b;
        XOR: logic_res = a ^ b;
        NOR: logic_res = ~(a | b);
        default: logic_res = 32'b0;
    endcase
end

// Shift
always @* begin
    case (aluc)
        SLL:  shift_res = shl(b, shamt_fixed);
        SRL:  shift_res = shr_logical(b, shamt_fixed);
        SRA:  shift_res = shr_arith(b_s, shamt_fixed);
        SLLV: shift_res = shl(b, shamt_var);
        SRLV: shift_res = shr_logical(b, shamt_var);
        SRAV: shift_res = shr_arith(b_s, shamt_var);
        default: shift_res = 32'b0;
    endcase
end

// SLT/SLTU flag computation
always @* begin
    slt_flag = (a_s < b_s) ? 1'b1 : 1'b0;
    sltu_flag = (a < b) ? 1'b1 : 1'b0;
end

// Main mux for final result and flags
always @* begin
    // Default outputs
    alu_res = 32'bz;
    alu_carry = 1'b0;
    alu_overflow = 1'b0;
    alu_flag = 1'bz;

    case (aluc)
        ADD: begin
            alu_res = add_res[31:0];
            alu_carry = add_res[32];
            alu_overflow = add_overflow;
            alu_flag = 1'bz;
        end
        ADDU: begin
            alu_res = add_res[31:0];
            alu_carry = add_res[32];
            alu_overflow = 1'b0;
            alu_flag = 1'bz;
        end
        SUB: begin
            alu_res = sub_res[31:0];
            alu_carry = sub_res[32]; // borrow bit (carry=1 means no borrow)
            alu_overflow = sub_overflow;
            alu_flag = 1'bz;
        end
        SUBU: begin
            alu_res = sub_res[31:0];
            alu_carry = sub_res[32];
            alu_overflow = 1'b0;
            alu_flag = 1'bz;
        end
        AND, OR, XOR, NOR: begin
            alu_res = logic_res;
            alu_carry = 1'b0;
            alu_overflow = 1'b0;
            alu_flag = 1'bz;
        end
        SLT: begin
            alu_res = {31'b0, slt_flag};
            alu_carry = 1'b0;
            alu_overflow = 1'b0;
            alu_flag = 1'b1;
        end
        SLTU: begin
            alu_res = {31'b0, sltu_flag};
            alu_carry = 1'b0;
            alu_overflow = 1'b0;
            alu_flag = 1'b1;
        end
        SLL, SRL, SRA, SLLV, SRLV, SRAV: begin
            alu_res = shift_res;
            alu_carry = 1'b0;
            alu_overflow = 1'b0;
            alu_flag = 1'bz;
        end
        LUI: begin
            alu_res = {a[15:0], 16'b0};
            alu_carry = 1'b0;
            alu_overflow = 1'b0;
            alu_flag = 1'bz;
        end
        default: begin
            alu_res = 32'bz;
            alu_carry = 1'b0;
            alu_overflow = 1'b0;
            alu_flag = 1'bz;
        end
    endcase

    r = alu_res;
    carry = alu_carry;
    overflow = alu_overflow;
    flag = alu_flag;

    // zero and negative flags based on final result r
    zero = (r === 32'b0) ? 1'b1 : 1'b0;
    negative = r[31];
end

endmodule