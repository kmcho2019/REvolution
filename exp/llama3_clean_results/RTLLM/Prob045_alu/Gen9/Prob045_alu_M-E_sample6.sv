module alu_arithmetic(
    input [31:0] a,
    input [31:0] b,
    input [5:0] op,
    output [31:0] result,
    output zero,
    output carry,
    output negative,
    output overflow
);

parameter ADD = 6'b100000;
parameter SUB = 6'b100010;

assign result = (op == ADD) ? a + b :
                (op == SUB) ? a - b : 32'bz;

assign zero = (result == 32'h0);
assign carry = (op == ADD || op == SUB) ? (result[31] != a[31]) : 1'b0;
assign negative = result[31];
assign overflow = (op == ADD || op == SUB) ? (a[31] == b[31] && result[31] != a[31]) : 1'b0;

endmodule

module alu_logic(
    input [31:0] a,
    input [31:0] b,
    input [5:0] op,
    output [31:0] result
);

parameter AND = 6'b100100;
parameter OR = 6'b100101;
parameter XOR = 6'b100110;
parameter NOR = 6'b100111;

assign result = (op == AND) ? a & b :
                (op == OR) ? a | b :
                (op == XOR) ? a ^ b :
                (op == NOR) ? ~(a | b) : 32'bz;

endmodule

module alu_shift(
    input [31:0] a,
    input [4:0] shift_amount,
    input [1:0] op,
    output [31:0] result
);

parameter SLL = 2'b00;
parameter SRL = 2'b01;
parameter SRA = 2'b10;

assign result = (op == SLL) ? a << shift_amount :
                (op == SRL) ? a >> shift_amount :
                (op == SRA) ? a >>> shift_amount : 32'bz;

endmodule

module register_file(
    input [31:0] data_in,
    input [4:0] read_addr1,
    input [4:0] read_addr2,
    input [4:0] write_addr,
    input write_enable,
    output [31:0] data_out1,
    output [31:0] data_out2
);

reg [31:0] registers[31:0];

assign data_out1 = registers[read_addr1];
assign data_out2 = registers[read_addr2];

always @(posedge clk) begin
    if (write_enable) begin
        registers[write_addr] <= data_in;
    end
end

endmodule

module control_unit(
    input [5:0] op,
    output [31:0] result,
    output zero,
    output carry,
    output negative,
    output overflow,
    output flag
);

wire [31:0] arithmetic_result;
wire [31:0] logic_result;
wire [31:0] shift_result;

alu_arithmetic arithmetic_unit(.a(a), .b(b), .op(op), .result(arithmetic_result), .zero, .carry, .negative, .overflow);
alu_logic logic_unit(.a(a), .b(b), .op(op), .result(logic_result));
alu_shift shift_unit(.a(a), .shift_amount(shift_amount), .op(op[1:0]), .result(shift_result));

assign result = (op[5:4] == 2'b00) ? arithmetic_result :
                (op[5:4] == 2'b01) ? logic_result :
                (op[5:4] == 2'b10) ? shift_result : 32'bz;

assign flag = (op == SLT) ? (signed'(a) < signed'(b)) ? 1'b1 : 1'b0 :
               (op == SLTU) ? (a < b) ? 1'b1 : 1'b0 : 1'b0;

endmodule