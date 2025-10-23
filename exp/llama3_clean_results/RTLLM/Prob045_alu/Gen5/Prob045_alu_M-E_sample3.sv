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

// Instruction Decode (ID) stage
wire [31:0] id_a;
wire [31:0] id_b;
wire [5:0] id_aluc;
reg [31:0] id_result;
reg zero_id;
reg carry_id;
reg negative_id;
reg overflow_id;
reg flag_id;

always @(*) begin
    id_a = a;
    id_b = b;
    id_aluc = aluc;
    case (id_aluc)
        ADD, ADDU: begin
            {carry_id, id_result} = id_a + id_b;
            overflow_id = (id_a[31] == id_b[31] && id_result[31] != id_a[31]);
        end
        SUB, SUBU: begin
            {carry_id, id_result} = id_a - id_b;
            overflow_id = (id_a[31] != id_b[31] && id_result[31] != id_a[31]);
        end
        AND: id_result = id_a & id_b;
        OR: id_result = id_a | id_b;
        XOR: id_result = id_a ^ id_b;
        NOR: id_result = ~(id_a | id_b);
        SLT: id_result = (signed'(id_a) < signed'(id_b))? 32'h1 : 32'h0;
        SLTU: id_result = (id_a < id_b)? 32'h1 : 32'h0;
        SLL: id_result = id_a << id_b[4:0];
        SRL: id_result = id_a >> id_b[4:0];
        SRA: id_result = id_a >>> id_b[4:0];
        SLLV: id_result = id_a << id_a[4:0];
        SRLV: id_result = id_a >> id_a[4:0];
        SRAV: id_result = id_a >>> id_a[4:0];
        LUI: id_result = {16'd0, id_a[15:0]};
        default: id_result = 32'bz;
    endcase
    zero_id = (id_result == 32'h0);
    negative_id = id_result[31];
    flag_id = (id_aluc == SLT || id_aluc == SLTU)? id_result[0] : 1'b0;
end

// Operand Fetch (OF) stage
wire [31:0] of_a;
wire [31:0] of_b;
wire [5:0] of_aluc;
reg [31:0] of_result;
reg zero_of;
reg carry_of;
reg negative_of;
reg overflow_of;
reg flag_of;

always @(*) begin
    of_a = id_a;
    of_b = id_b;
    of_aluc = id_aluc;
    of_result = id_result;
    zero_of = zero_id;
    carry_of = carry_id;
    negative_of = negative_id;
    overflow_of = overflow_id;
    flag_of = flag_id;
end

// Execution (EX) stage
wire [31:0] ex_a;
wire [31:0] ex_b;
wire [5:0] ex_aluc;
reg [31:0] ex_result;
reg zero_ex;
reg carry_ex;
reg negative_ex;
reg overflow_ex;
reg flag_ex;

always @(*) begin
    ex_a = of_a;
    ex_b = of_b;
    ex_aluc = of_aluc;
    ex_result = of_result;
    zero_ex = zero_of;
    carry_ex = carry_of;
    negative_ex = negative_of;
    overflow_ex = overflow_of;
    flag_ex = flag_of;
end

// Write Back (WB) stage
reg [31:0] wb_result;
reg zero_wb;
reg carry_wb;
reg negative_wb;
reg overflow_wb;
reg flag_wb;

always @(*) begin
    wb_result = ex_result;
    zero_wb = zero_ex;
    carry_wb = carry_ex;
    negative_wb = negative_ex;
    overflow_wb = overflow_ex;
    flag_wb = flag_ex;
end

// Output assignments
assign r = wb_result;
assign zero = zero_wb;
assign carry = carry_wb;
assign negative = negative_wb;
assign overflow = overflow_wb;
assign flag = flag_wb;

endmodule