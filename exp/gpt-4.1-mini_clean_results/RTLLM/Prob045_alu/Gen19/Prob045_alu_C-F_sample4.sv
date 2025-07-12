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

    // Opcode parameters
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

    // Signed versions of inputs for SLT and SRA/SRAV
    wire signed [31:0] a_s = $signed(a);
    wire signed [31:0] b_s = $signed(b);

    // Shift amount for fixed shift instructions (SLL, SRL, SRA)
    wire [4:0] shamt = a[4:0];

    // 33-bit addition and subtraction for carry detection
    wire [32:0] add_ext = {1'b0, a} + {1'b0, b};
    wire [32:0] sub_ext = {1'b0, a} - {1'b0, b};

    // Extract results and carry outs
    wire [31:0] add_res = add_ext[31:0];
    wire [31:0] sub_res = sub_ext[31:0];
    wire        add_carry = add_ext[32];
    wire        sub_carry = sub_ext[32];

    // Overflow detection for signed add: overflow if adding two positives yields negative or two negatives yield positive
    wire add_overflow = (~a[31] & ~b[31] & add_res[31]) | (a[31] & b[31] & ~add_res[31]);
    // Overflow detection for signed sub: overflow if signs differ and result sign doesn't match a's sign
    wire sub_overflow = (a[31] & ~b[31] & ~sub_res[31]) | (~a[31] & b[31] & sub_res[31]);

    // SLT flag for signed comparison
    wire slt_flag  = (a_s < b_s);
    // SLTU flag for unsigned comparison
    wire sltu_flag = (a < b);

    // Result mux based on aluc
    wire [31:0] res = (aluc == ADD)  ? add_res :
                      (aluc == ADDU) ? add_res :    // unsigned add, carry handled separately
                      (aluc == SUB)  ? sub_res :
                      (aluc == SUBU) ? sub_res :    // unsigned sub
                      (aluc == AND)  ? (a & b) :
                      (aluc == OR)   ? (a | b) :
                      (aluc == XOR)  ? (a ^ b) :
                      (aluc == NOR)  ? ~(a | b) :
                      (aluc == SLT)  ? {31'b0, slt_flag} :
                      (aluc == SLTU) ? {31'b0, sltu_flag} :
                      (aluc == SLL)  ? (b << shamt) :
                      (aluc == SRL)  ? (b >> shamt) :
                      (aluc == SRA)  ? $signed(b_s) >>> shamt :
                      (aluc == SLLV) ? (b << a[4:0]) :
                      (aluc == SRLV) ? (b >> a[4:0]) :
                      (aluc == SRAV) ? $signed(b_s) >>> a[4:0] :
                      (aluc == LUI)  ? {a[15:0], 16'b0} :
                      32'b0;

    // Carry and overflow output mux
    wire carry_out = (aluc == ADD || aluc == ADDU) ? add_carry :
                     (aluc == SUB || aluc == SUBU) ? sub_carry :
                     1'b0;

    wire overflow_out = (aluc == ADD) ? add_overflow :
                        (aluc == SUB) ? sub_overflow :
                        1'b0;

    // Flag output only meaningful for SLT and SLTU; otherwise zero
    wire flag_out = (aluc == SLT) ? slt_flag :
                    (aluc == SLTU) ? sltu_flag :
                    1'b0;

    // Zero and negative flags directly from result
    wire zero_out = (res == 32'b0);
    wire negative_out = res[31];

    // Output assignments
    assign r        = res;
    assign zero     = zero_out;
    assign carry    = carry_out;
    assign negative = negative_out;
    assign overflow = overflow_out;
    assign flag     = flag_out;

endmodule