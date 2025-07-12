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

// Intermediate carry and overflow calculations for ADD/SUB operations
wire [32:0] add_ext = {1'b0, a} + {1'b0, b};
wire [32:0] sub_ext = {1'b0, a} - {1'b0, b};

wire add_carry = add_ext[32];
wire sub_carry = sub_ext[32];

wire signed [31:0] add_res = add_ext[31:0];
wire signed [31:0] sub_res = sub_ext[31:0];

// Overflow detection for ADD and SUB
wire add_overflow = (~a[31] & ~b[31] & add_res[31]) | (a[31] & b[31] & ~add_res[31]);
wire sub_overflow = (a[31] & ~b[31] & ~sub_res[31]) | (~a[31] & b[31] & sub_res[31]);

// Flags for SLT and SLTU
wire slt_flag = (a_s < b_s);
wire sltu_flag = (a < b);

// Shift amounts for instructions using variable shifts
wire [4:0] shamt_var = a[4:0];

// Result mux
wire [31:0] res = (aluc == ADD)  ? add_res  :
                  (aluc == ADDU) ? add_ext[31:0] :
                  (aluc == SUB)  ? sub_res  :
                  (aluc == SUBU) ? sub_ext[31:0] :
                  (aluc == AND)  ? (a & b)  :
                  (aluc == OR)   ? (a | b)  :
                  (aluc == XOR)  ? (a ^ b)  :
                  (aluc == NOR)  ? ~(a | b) :
                  (aluc == SLT)  ? {31'd0, slt_flag} :
                  (aluc == SLTU) ? {31'd0, sltu_flag} :
                  (aluc == SLL)  ? (b << shamt) :
                  (aluc == SRL)  ? (b >> shamt) :
                  (aluc == SRA)  ? $signed(b_s) >>> shamt :
                  (aluc == SLLV) ? (b << shamt_var) :
                  (aluc == SRLV) ? (b >> shamt_var) :
                  (aluc == SRAV) ? $signed(b_s) >>> shamt_var :
                  (aluc == LUI)  ? {a[15:0], 16'b0} :
                  32'b0;

// Carry out signal mux (only meaningful for ADD, ADDU, SUB, SUBU)
wire carry_out = (aluc == ADD)  ? add_carry  :
                 (aluc == ADDU) ? add_carry  :
                 (aluc == SUB)  ? sub_carry  :
                 (aluc == SUBU) ? sub_carry  :
                 1'b0;

// Overflow out signal mux
wire overflow_out = (aluc == ADD) ? add_overflow :
                    (aluc == SUB) ? sub_overflow :
                    1'b0;

// Flag output only valid for SLT and SLTU, else 0
wire flag_out = (aluc == SLT)  ? slt_flag :
                (aluc == SLTU) ? sltu_flag :
                1'b0;

// Zero and negative flags derived directly from result
wire zero_out = (res == 32'b0);
wire negative_out = res[31];

// Output assignments
assign r        = res;
assign carry    = carry_out;
assign overflow = overflow_out;
assign flag     = flag_out;
assign zero     = zero_out;
assign negative = negative_out;

endmodule