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

wire signed [31:0] a_s = $signed(a);
wire signed [31:0] b_s = $signed(b);
wire [4:0] shamt = a[4:0];

// Functions for operations
function [32:0] add_with_carry; // returns 33 bits: carry + 32 result
    input [31:0] x, y;
    begin
        add_with_carry = {1'b0, x} + {1'b0, y};
    end
endfunction

function [32:0] sub_with_borrow; // returns 33 bits: carry + 32 result
    input [31:0] x, y;
    reg [32:0] tmp;
    begin
        tmp = {1'b0, x} - {1'b0, y};
        // In subtraction, carry = 1 if no borrow, else 0
        // So carry bit as the NOT borrow bit
        sub_with_borrow = tmp;
    end
endfunction

function logic overflow_add;
    input [31:0] x, y, res;
    begin
        overflow_add = (~x[31] & ~y[31] & res[31]) | (x[31] & y[31] & ~res[31]);
    end
endfunction

function logic overflow_sub;
    input [31:0] x, y, res;
    begin
        overflow_sub = (x[31] & ~y[31] & ~res[31]) | (~x[31] & y[31] & res[31]);
    end
endfunction

// Intermediate wires for each operation
wire [32:0] add_res  = add_with_carry(a, b);
wire [32:0] addu_res = add_with_carry(a, b);
wire [32:0] sub_res  = sub_with_borrow(a, b);
wire [32:0] subu_res = sub_with_borrow(a, b);

wire [31:0] and_res = a & b;
wire [31:0] or_res  = a | b;
wire [31:0] xor_res = a ^ b;
wire [31:0] nor_res = ~(a | b);

wire slt_flag  = (a_s < b_s)  ? 1'b1 : 1'b0;
wire sltu_flag = (a < b)     ? 1'b1 : 1'b0;

wire [31:0] slt_res  = {31'b0, slt_flag};
wire [31:0] sltu_res = {31'b0, sltu_flag};

wire [31:0] sll_res  = b << shamt;
wire [31:0] srl_res  = b >> shamt;
wire [31:0] sra_res  = $signed(b_s) >>> shamt;
wire [31:0] sllv_res = b << a[4:0];
wire [31:0] srlv_res = b >> a[4:0];
wire [31:0] srav_res = $signed(b_s) >>> a[4:0];

wire [31:0] lui_res  = {a[15:0], 16'b0};

// Default outputs
reg [31:0] r_reg;
reg        carry_reg;
reg        overflow_reg;
reg        flag_reg;

always @(*) begin
    r_reg = 32'b0;
    carry_reg = 1'b0;
    overflow_reg = 1'b0;
    flag_reg = 1'b0;

    case(aluc)
        ADD: begin
            r_reg = add_res[31:0];
            carry_reg = add_res[32];
            overflow_reg = overflow_add(a, b, r_reg);
            flag_reg = 1'b0;
        end
        ADDU: begin
            r_reg = addu_res[31:0];
            carry_reg = addu_res[32];
            overflow_reg = 1'b0;
            flag_reg = 1'b0;
        end
        SUB: begin
            r_reg = sub_res[31:0];
            carry_reg = (a >= b) ? 1'b1 : 1'b0;
            overflow_reg = overflow_sub(a, b, r_reg);
            flag_reg = 1'b0;
        end
        SUBU: begin
            r_reg = subu_res[31:0];
            carry_reg = (a >= b) ? 1'b1 : 1'b0;
            overflow_reg = 1'b0;
            flag_reg = 1'b0;
        end
        AND: begin
            r_reg = and_res;
            carry_reg = 1'b0;
            overflow_reg = 1'b0;
            flag_reg = 1'b0;
        end
        OR: begin
            r_reg = or_res;
            carry_reg = 1'b0;
            overflow_reg = 1'b0;
            flag_reg = 1'b0;
        end
        XOR: begin
            r_reg = xor_res;
            carry_reg = 1'b0;
            overflow_reg = 1'b0;
            flag_reg = 1'b0;
        end
        NOR: begin
            r_reg = nor_res;
            carry_reg = 1'b0;
            overflow_reg = 1'b0;
            flag_reg = 1'b0;
        end
        SLT: begin
            r_reg = slt_res;
            carry_reg = 1'b0;
            overflow_reg = 1'b0;
            flag_reg = slt_flag;
        end
        SLTU: begin
            r_reg = sltu_res;
            carry_reg = 1'b0;
            overflow_reg = 1'b0;
            flag_reg = sltu_flag;
        end
        SLL: begin
            r_reg = sll_res;
            carry_reg = 1'b0;
            overflow_reg = 1'b0;
            flag_reg = 1'b0;
        end
        SRL: begin
            r_reg = srl_res;
            carry_reg = 1'b0;
            overflow_reg = 1'b0;
            flag_reg = 1'b0;
        end
        SRA: begin
            r_reg = sra_res;
            carry_reg = 1'b0;
            overflow_reg = 1'b0;
            flag_reg = 1'b0;
        end
        SLLV: begin
            r_reg = sllv_res;
            carry_reg = 1'b0;
            overflow_reg = 1'b0;
            flag_reg = 1'b0;
        end
        SRLV: begin
            r_reg = srlv_res;
            carry_reg = 1'b0;
            overflow_reg = 1'b0;
            flag_reg = 1'b0;
        end
        SRAV: begin
            r_reg = srav_res;
            carry_reg = 1'b0;
            overflow_reg = 1'b0;
            flag_reg = 1'b0;
        end
        LUI: begin
            r_reg = lui_res;
            carry_reg = 1'b0;
            overflow_reg = 1'b0;
            flag_reg = 1'b0;
        end
        default: begin
            r_reg = 32'bz; // high impedance for invalid
            carry_reg = 1'b0;
            overflow_reg = 1'b0;
            flag_reg = 1'b0;
        end
    endcase
end

assign r        = r_reg;
assign zero     = (r_reg == 32'b0);
assign negative = r_reg[31];
assign carry    = carry_reg;
assign overflow = overflow_reg;
assign flag     = ( (aluc == SLT) || (aluc == SLTU) ) ? flag_reg : 1'bz;

endmodule