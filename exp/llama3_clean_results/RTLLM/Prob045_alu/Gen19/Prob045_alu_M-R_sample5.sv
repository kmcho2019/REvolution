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

// Operation categories
parameter ADD = 6'b100000;
parameter SUB = 6'b100010;
parameter ADDU = 6'b100001;
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
parameter LUI = 6'b001111;
parameter SLLV = 6'b000100;
parameter SRLV = 6'b000110;
parameter SRAV = 6'b000111;

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
reg [31:0] lui_result;
reg [31:0] sllv_result;
reg [31:0] srlev_result;
reg [31:0] srav_result;

assign zero = (r == 32'd0);
assign negative = r[31];
assign flag = (aluc == SLT || aluc == SLTU) ? (r[0] == 1'b1) : 1'b0;

always @(*) begin
    case (aluc)
        ADD: begin
            r = a + b;
            carry = (a[31] != b[31]) && (a[31] != r[31]);
            overflow = (a[31] == 1'b1) && (b[31] == 1'b1) && (r[31] == 1'b0);
        end
        ADDU: begin
            r = a + b;
            carry = (a[31] != b[31]) && (a[31] != r[31]);
            overflow = 1'b0;
        end
        SUB: begin
            r = a - b;
            carry = (a[31] == b[31]) && (a[31] != r[31]);
            overflow = (a[31] == 1'b0) && (b[31] == 1'b1) && (r[31] == 1'b1);
        end
        SUBU: begin
            r = a - b;
            carry = (a[31] == b[31]) && (a[31] != r[31]);
            overflow = 1'b0;
        end
        AND: begin
            r = a & b;
            carry = 1'b0;
            overflow = 1'b0;
        end
        OR: begin
            r = a | b;
            carry = 1'b0;
            overflow = 1'b0;
        end
        XOR: begin
            r = a ^ b;
            carry = 1'b0;
            overflow = 1'b0;
        end
        NOR: begin
            r = ~(a | b);
            carry = 1'b0;
            overflow = 1'b0;
        end
        SLT: begin
            r = (signed'(a) < signed'(b)) ? 32'd1 : 32'd0;
            carry = 1'b0;
            overflow = 1'b0;
        end
        SLTU: begin
            r = (a < b) ? 32'd1 : 32'd0;
            carry = 1'b0;
            overflow = 1'b0;
        end
        SLL: begin
            r = a << b[4:0];
            carry = 1'b0;
            overflow = 1'b0;
        end
        SRL: begin
            r = a >> b[4:0];
            carry = 1'b0;
            overflow = 1'b0;
        end
        SRA: begin
            r = a >>> b[4:0];
            carry = 1'b0;
            overflow = 1'b0;
        end
        LUI: begin
            r = {b[15:0], 16'd0};
            carry = 1'b0;
            overflow = 1'b0;
        end
        SLLV: begin
            r = a << b[4:0];
            carry = 1'b0;
            overflow = 1'b0;
        end
        SRLV: begin
            r = a >> b[4:0];
            carry = 1'b0;
            overflow = 1'b0;
        end
        SRAV: begin
            r = a >>> b[4:0];
            carry = 1'b0;
            overflow = 1'b0;
        end
        default: begin
            r = 32'd0;
            carry = 1'b0;
            overflow = 1'b0;
        end
    endcase
end

endmodule