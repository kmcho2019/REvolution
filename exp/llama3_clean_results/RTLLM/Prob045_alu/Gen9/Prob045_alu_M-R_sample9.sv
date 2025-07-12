module alu(
    input [31:0] a,
    input [31:0] b,
    input [5:0] aluc,
    output [31:0] r,
    output zero,
    output carry,
    output negative,
    output overflow,
    output flag
);

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

wire [31:0] add_result, sub_result;
wire [31:0] and_result, or_result, xor_result, nor_result;
wire [31:0] sll_result, srl_result, sra_result, sllv_result, srlv_result, srav_result;
wire [31:0] slt_result, sltu_result;
wire [31:0] lui_result;

// Arithmetic Operations
assign {carry, add_result} = a + b;
assign {carry, sub_result} = a - b;

// Bitwise Operations
assign and_result = a & b;
assign or_result = a | b;
assign xor_result = a ^ b;
assign nor_result = ~(a | b);

// Shift Operations
assign sll_result = a << b[4:0];
assign srl_result = a >> b[4:0];
assign sra_result = a >>> b[4:0];
assign sllv_result = a << a[4:0];
assign srlv_result = a >> a[4:0];
assign srav_result = a >>> a[4:0];

// Comparison Operations
assign slt_result = (signed'(a) < signed'(b)) ? 32'h1 : 32'h0;
assign sltu_result = (a < b) ? 32'h1 : 32'h0;

// Load Upper Immediate
assign lui_result = {16'd0, a[15:0]};

// Output Logic
always @(a, b, aluc) begin
    case (aluc)
        ADD, ADDU: begin
            r = add_result;
            overflow = (a[31] == b[31] && r[31] != a[31]);
            flag = 1'b0;
        end
        SUB, SUBU: begin
            r = sub_result;
            overflow = (a[31] != b[31] && r[31] != a[31]);
            flag = 1'b0;
        end
        AND: begin
            r = and_result;
            overflow = 1'b0;
            flag = 1'b0;
        end
        OR: begin
            r = or_result;
            overflow = 1'b0;
            flag = 1'b0;
        end
        XOR: begin
            r = xor_result;
            overflow = 1'b0;
            flag = 1'b0;
        end
        NOR: begin
            r = nor_result;
            overflow = 1'b0;
            flag = 1'b0;
        end
        SLT: begin
            r = slt_result;
            overflow = 1'b0;
            flag = r[0];
        end
        SLTU: begin
            r = sltu_result;
            overflow = 1'b0;
            flag = r[0];
        end
        SLL: begin
            r = sll_result;
            overflow = 1'b0;
            flag = 1'b0;
        end
        SRL: begin
            r = srl_result;
            overflow = 1'b0;
            flag = 1'b0;
        end
        SRA: begin
            r = sra_result;
            overflow = 1'b0;
            flag = 1'b0;
        end
        SLLV: begin
            r = sllv_result;
            overflow = 1'b0;
            flag = 1'b0;
        end
        SRLV: begin
            r = srlv_result;
            overflow = 1'b0;
            flag = 1'b0;
        end
        SRAV: begin
            r = srav_result;
            overflow = 1'b0;
            flag = 1'b0;
        end
        LUI: begin
            r = lui_result;
            overflow = 1'b0;
            flag = 1'b0;
        end
        default: r = 32'bz;
    endcase
    zero = (r == 32'h0);
    negative = r[31];
end

assign carry = (aluc == ADD || aluc == ADDU || aluc == SUB || aluc == SUBU) ? carry : 1'b0;

endmodule