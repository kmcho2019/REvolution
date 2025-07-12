// alu.v
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

// Arithmetic operations
wire [31:0] add_result;
wire [31:0] sub_result;

// Shift operations
wire [31:0] sll_result;
wire [31:0] srl_result;
wire [31:0] sra_result;

// Logical operations
wire [31:0] and_result;
wire [31:0] or_result;
wire [31:0] xor_result;
wire [31:0] nor_result;

// Comparison operations
wire [31:0] slt_result;
wire [31:0] sltu_result;

// LUI operation
wire [31:0] lui_result;

// Instantiate modules for different operations
add_sub add_sub_inst(
    .a(a),
    .b(b),
    .add_sub(aluc[0]),
    .result(add_result),
    .carry(carry),
    .overflow(overflow)
);

shift shift_inst(
    .a(a),
    .b(b[4:0]),
    .shift_type(aluc[1:0]),
    .result(sll_result),
    .sll(sll_result),
    .srl(srl_result),
    .sra(sra_result)
);

logical logical_inst(
    .a(a),
    .b(b),
    .logical_type(aluc[2:1]),
    .result(and_result),
    .and(and_result),
    .or(or_result),
    .xor(xor_result),
    .nor(nor_result)
);

comparison comparison_inst(
    .a(a),
    .b(b),
    .comparison_type(aluc[3:2]),
    .result(slt_result),
    .slt(slt_result),
    .sltu(sltu_result)
);

lui lui_inst(
    .b(b),
    .result(lui_result)
);

// Mux for selecting the result
always @(*) begin
    case (aluc)
        ADD, ADDU: r = add_result;
        SUB, SUBU: r = sub_result;
        SLL, SLLV: r = sll_result;
        SRL, SRLV: r = srl_result;
        SRA, SRAV: r = sra_result;
        AND: r = and_result;
        OR: r = or_result;
        XOR: r = xor_result;
        NOR: r = nor_result;
        SLT: r = slt_result;
        SLTU: r = sltu_result;
        LUI: r = lui_result;
        default: r = 32'bx;
    endcase
    zero = (r == 32'd0);
    negative = r[31];
    flag = (aluc == SLT || aluc == SLTU) ? (r[0] == 1'b1) : 1'bx;
end

endmodule

// add_sub.v
module add_sub(
    input [31:0] a,
    input [31:0] b,
    input add_sub,
    output reg [31:0] result,
    output reg carry,
    output reg overflow
);

always @(*) begin
    if (add_sub) begin
        {carry, result} = a + b;
        overflow = (a[31] == b[31] && a[31]!= result[31]);
    end else begin
        {carry, result} = a - b;
        overflow = (a[31]!= b[31] && a[31]!= result[31]);
    end
end

endmodule

// shift.v
module shift(
    input [31:0] a,
    input [4:0] b,
    input [1:0] shift_type,
    output reg [31:0] result,
    output reg [31:0] sll,
    output reg [31:0] srl,
    output reg [31:0] sra
);

always @(*) begin
    case (shift_type)
        2'b00: begin
            sll = a << b;
            srl = 32'bx;
            sra = 32'bx;
            result = sll;
        end
        2'b01: begin
            srl = a >> b;
            sll = 32'bx;
            sra = 32'bx;
            result = srl;
        end
        2'b10: begin
            sra = $signed(a) >>> b;
            sll = 32'bx;
            srl = 32'bx;
            result = sra;
        end
        default: begin
            sll = 32'bx;
            srl = 32'bx;
            sra = 32'bx;
            result = 32'bx;
        end
    endcase
end

endmodule

// logical.v
module logical(
    input [31:0] a,
    input [31:0] b,
    input [1:0] logical_type,
    output reg [31:0] result,
    output reg [31:0] and,
    output reg [31:0] or,
    output reg [31:0] xor,
    output reg [31:0] nor
);

always @(*) begin
    case (logical_type)
        2'b00: begin
            and = a & b;
            or = 32'bx;
            xor = 32'bx;
            nor = 32'bx;
            result = and;
        end
        2'b01: begin
            or = a | b;
            and = 32'bx;
            xor = 32'bx;
            nor = 32'bx;
            result = or;
        end
        2'b10: begin
            xor = a ^ b;
            and = 32'bx;
            or = 32'bx;
            nor = 32'bx;
            result = xor;
        end
        2'b11: begin
            nor = ~(a | b);
            and = 32'bx;
            or = 32'bx;
            xor = 32'bx;
            result = nor;
        end
        default: begin
            and = 32'bx;
            or = 32'bx;
            xor = 32'bx;
            nor = 32'bx;
            result = 32'bx;
        end
    endcase
end

endmodule

// comparison.v
module comparison(
    input [31:0] a,
    input [31:0] b,
    input [1:0] comparison_type,
    output reg [31:0] result,
    output reg [31:0] slt,
    output reg [31:0] sltu
);

always @(*) begin
    case (comparison_type)
        2'b00: begin
            slt = ($signed(a) < $signed(b)) ? 32'd1 : 32'd0;
            sltu = 32'bx;
            result = slt;
        end
        2'b01: begin
            sltu = (a < b) ? 32'd1 : 32'd0;
            slt = 32'bx;
            result = sltu;
        end
        default: begin
            slt = 32'bx;
            sltu = 32'bx;
            result = 32'bx;
        end
    endcase
end

endmodule

// lui.v
module lui(
    input [15:0] b,
    output reg [31:0] result
);

always @(*) begin
    result = {b, 16'd0};
end

endmodule