module alu(
    input [31:0] a,
    input [31:0] b,
    input [5:0] aluc,
    output reg [31:0] r,
    output reg zero,
    output reg carry,
    output reg negative,
    output reg overflow,
    output reg flag
);

// Define operation codes
parameter ADD = 6'b100000;
parameter ADDU = 6'b100001;
parameter SUB = 6'b100010;
parameter SUBU = 6'b100011;
parameter AND = 6'b100100;
parameter OR = 6'b100101;
parameter XOR = 6'b100110;
parameter NOR = 6'b100111;
parameter SLT = 6'b101010;
parameter SLTU = 6'b101011;
parameter SLL = 6'b000000;
parameter SRL = 6'b000010;
parameter SRA = 6'b000011;
parameter SLLV = 6'b000100;
parameter SRLV = 6'b000110;
parameter SRAV = 6'b000111;
parameter LUI = 6'b001111;

// Internal signals
reg [31:0] add_result;
reg [31:0] sub_result;
reg [31:0] and_result;
reg [31:0] or_result;
reg [31:0] xor_result;
reg [31:0] nor_result;
reg [31:0] slt_result;
reg [31:0] sltu_result;
reg [31:0] sll_result;
reg [31:0] srl_result;
reg [31:0] sra_result;
reg [31:0] sllv_result;
reg [31:0] srlv_result;
reg [31:0] srav_result;
reg [31:0] lui_result;

// Lookup tables for operations
always @(a, b) begin
    add_result = a + b;
    sub_result = a - b;
    and_result = a & b;
    or_result = a | b;
    xor_result = a ^ b;
    nor_result = ~(a | b);
    slt_result = (a < b) ? 32'd1 : 32'd0;
    sltu_result = (a < b) ? 32'd1 : 32'd0;
    sll_result = a << b[4:0];
    srl_result = a >> b[4:0];
    sra_result = a >>> b[4:0];
    sllv_result = a << b[4:0];
    srlv_result = a >> b[4:0];
    srav_result = a >>> b[4:0];
    lui_result = {16'b0, a[15:0]};
end

// Multiplexer to select operation result
always @(aluc) begin
    case (aluc)
        ADD: r = add_result;
        ADDU: r = add_result;
        SUB: r = sub_result;
        SUBU: r = sub_result;
        AND: r = and_result;
        OR: r = or_result;
        XOR: r = xor_result;
        NOR: r = nor_result;
        SLT: r = slt_result;
        SLTU: r = sltu_result;
        SLL: r = sll_result;
        SRL: r = srl_result;
        SRA: r = sra_result;
        SLLV: r = sllv_result;
        SRLV: r = srlv_result;
        SRAV: r = srav_result;
        LUI: r = lui_result;
        default: r = 32'bx;
    endcase
end

// Flags calculation
always @(r) begin
    zero = (r == 32'd0) ? 1'b1 : 1'b0;
    carry = (r[31] == 1'b1) ? 1'b1 : 1'b0;
    negative = (r[31] == 1'b1) ? 1'b1 : 1'b0;
    overflow = ((r[31] == 1'b1) && (a[31] != b[31])) ? 1'b1 : 1'b0;
    flag = (aluc == SLT || aluc == SLTU) ? (r != 32'd0) : 1'b0;
end

endmodule