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

reg [31:0] result;
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

// Clocked always block
always @(posedge clock) begin
    case (aluc)
        ADD: begin
            add_result = a + b;
            result = add_result;
            carry = (a[31] != b[31]) && (a[31] != result[31]);
            overflow = (a[31] == 1'b1) && (b[31] == 1'b1) && (result[31] == 1'b0);
        end
        ADDU: begin
            add_result = a + b;
            result = add_result;
            carry = (a[31] != b[31]) && (a[31] != result[31]);
            overflow = 1'b0;
        end
        SUB: begin
            sub_result = a - b;
            result = sub_result;
            carry = (a[31] == b[31]) && (a[31] != result[31]);
            overflow = (a[31] == 1'b0) && (b[31] == 1'b1) && (result[31] == 1'b1);
        end
        SUBU: begin
            sub_result = a - b;
            result = sub_result;
            carry = (a[31] == b[31]) && (a[31] != result[31]);
            overflow = 1'b0;
        end
        AND: begin
            and_result = a & b;
            result = and_result;
            carry = 1'b0;
            overflow = 1'b0;
        end
        OR: begin
            or_result = a | b;
            result = or_result;
            carry = 1'b0;
            overflow = 1'b0;
        end
        XOR: begin
            xor_result = a ^ b;
            result = xor_result;
            carry = 1'b0;
            overflow = 1'b0;
        end
        NOR: begin
            nor_result = ~(a | b);
            result = nor_result;
            carry = 1'b0;
            overflow = 1'b0;
        end
        SLT: begin
            slt_result = (signed'(a) < signed'(b)) ? 32'd1 : 32'd0;
            result = slt_result;
            carry = 1'b0;
            overflow = 1'b0;
        end
        SLTU: begin
            sltu_result = (a < b) ? 32'd1 : 32'd0;
            result = sltu_result;
            carry = 1'b0;
            overflow = 1'b0;
        end
        SLL: begin
            sll_result = a << b[4:0];
            result = sll_result;
            carry = 1'b0;
            overflow = 1'b0;
        end
        SRL: begin
            srl_result = a >> b[4:0];
            result = srl_result;
            carry = 1'b0;
            overflow = 1'b0;
        end
        SRA: begin
            sra_result = a >>> b[4:0];
            result = sra_result;
            carry = 1'b0;
            overflow = 1'b0;
        end
        LUI: begin
            lui_result = {b[15:0], 16'd0};
            result = lui_result;
            carry = 1'b0;
            overflow = 1'b0;
        end
        SLLV: begin
            sllv_result = a << b[4:0];
            result = sllv_result;
            carry = 1'b0;
            overflow = 1'b0;
        end
        SRLV: begin
            srlev_result = a >> b[4:0];
            result = srlev_result;
            carry = 1'b0;
            overflow = 1'b0;
        end
        SRAV: begin
            srav_result = a >>> b[4:0];
            result = srav_result;
            carry = 1'b0;
            overflow = 1'b0;
        end
        default: begin
            result = 32'd0;
            carry = 1'b0;
            overflow = 1'b0;
        end
    endcase
    r = result;
    zero = (result == 32'd0);
    negative = result[31];
    flag = (aluc == SLT || aluc == SLTU) ? (result[0] == 1'b1) : 1'b0;
end

endmodule