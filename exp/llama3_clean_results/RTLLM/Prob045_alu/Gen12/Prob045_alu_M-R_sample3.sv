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

// Arithmetic Operations
wire [31:0] add_result;
wire [31:0] addu_result;
wire [31:0] sub_result;
wire [31:0] subu_result;

assign add_result = a + b;
assign addu_result = a + b;
assign sub_result = a - b;
assign subu_result = a - b;

// Logical Operations
wire [31:0] and_result;
wire [31:0] or_result;
wire [31:0] xor_result;
wire [31:0] nor_result;

assign and_result = a & b;
assign or_result = a | b;
assign xor_result = a ^ b;
assign nor_result = ~(a | b);

// Shift Operations
wire [31:0] sll_result;
wire [31:0] srl_result;
wire [31:0] sra_result;
wire [31:0] sllv_result;
wire [31:0] srlv_result;
wire [31:0] srav_result;

assign sll_result = a << b[4:0];
assign srl_result = a >> b[4:0];
assign sra_result = a >>> b[4:0];
assign sllv_result = a << a[4:0];
assign srlv_result = a >> a[4:0];
assign srav_result = a >>> a[4:0];

// Load Upper Immediate
wire [31:0] lui_result;

assign lui_result = {16'd0, a[15:0]};

// Result Multiplexing
assign r = (aluc == ADD)? add_result :
            (aluc == ADDU)? addu_result :
            (aluc == SUB)? sub_result :
            (aluc == SUBU)? subu_result :
            (aluc == AND)? and_result :
            (aluc == OR)? or_result :
            (aluc == XOR)? xor_result :
            (aluc == NOR)? nor_result :
            (aluc == SLL)? sll_result :
            (aluc == SRL)? srl_result :
            (aluc == SRA)? sra_result :
            (aluc == SLLV)? sllv_result :
            (aluc == SRLV)? srlv_result :
            (aluc == SRAV)? srav_result :
            (aluc == LUI)? lui_result :
            32'bz;

// Flag Handling
assign zero = (r == 32'h0);
assign negative = r[31];
assign carry = (aluc == ADD)? (a[31] == b[31] && r[31]!= a[31]) :
                (aluc == ADDU)? 1'b0 :
                (aluc == SUB)? (a[31]!= b[31] && r[31]!= a[31]) :
                (aluc == SUBU)? 1'b0 :
                1'b0;
assign overflow = (aluc == ADD)? (a[31] == b[31] && r[31]!= a[31]) :
                    (aluc == ADDU)? 1'b0 :
                    (aluc == SUB)? (a[31]!= b[31] && r[31]!= a[31]) :
                    (aluc == SUBU)? 1'b0 :
                    1'b0;
assign flag = (aluc == SLT)? (signed'(a) < signed'(b)) :
                (aluc == SLTU)? (a < b) :
                1'b0;

endmodule