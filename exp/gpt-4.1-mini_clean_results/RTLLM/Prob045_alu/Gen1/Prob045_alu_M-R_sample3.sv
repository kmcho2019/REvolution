module alu (
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

    // Define operation parameters
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

    // Signed versions of a and b for signed operations
    wire signed [31:0] a_signed = a;
    wire signed [31:0] b_signed = b;

    // Shift amounts extracted from a (5-bit)
    wire [4:0] shamt = a[4:0];

    // Intermediate 33-bit sums for carry/borrow detection
    wire [32:0] add_res  = {1'b0, a} + {1'b0, b};
    wire [32:0] addu_res = {1'b0, a} + {1'b0, b};
    wire [32:0] sub_res  = {1'b0, a} - {1'b0, b};
    wire [32:0] subu_res = {1'b0, a} - {1'b0, b};

    // Logical operations
    wire [31:0] and_res = a & b;
    wire [31:0] or_res  = a | b;
    wire [31:0] xor_res = a ^ b;
    wire [31:0] nor_res = ~(a | b);

    // SLT and SLTU results
    wire [31:0] slt_res  = (a_signed < b_signed) ? 32'd1 : 32'd0;
    wire [31:0] sltu_res = (a < b) ? 32'd1 : 32'd0;

    // Shift operations
    wire [31:0] sll_res  = b << shamt;
    wire [31:0] srl_res  = b >> shamt;
    wire [31:0] sra_res  = $signed(b) >>> shamt;
    wire [31:0] sllv_res = b << shamt;
    wire [31:0] srlv_res = b >> shamt;
    wire [31:0] srav_res = $signed(b) >>> shamt;

    // LUI operation
    wire [31:0] lui_res = {b[15:0], 16'b0};

    // Result multiplexer
    reg [31:0] r_reg;
    always @(*) begin
        case (aluc)
            ADD:  r_reg = add_res[31:0];
            ADDU: r_reg = addu_res[31:0];
            SUB:  r_reg = sub_res[31:0];
            SUBU: r_reg = subu_res[31:0];
            AND:  r_reg = and_res;
            OR:   r_reg = or_res;
            XOR:  r_reg = xor_res;
            NOR:  r_reg = nor_res;
            SLT:  r_reg = slt_res;
            SLTU: r_reg = sltu_res;
            SLL:  r_reg = sll_res;
            SRL:  r_reg = srl_res;
            SRA:  r_reg = sra_res;
            SLLV: r_reg = sllv_res;
            SRLV: r_reg = srlv_res;
            SRAV: r_reg = srav_res;
            LUI:  r_reg = lui_res;
            default: r_reg = 32'd0;
        endcase
    end

    assign r = r_reg;

    // Carry flag assignment
    // For ADD and ADDU: carry is the top bit of addition
    // For SUB and SUBU: carry is inverse of borrow (borrow = ~carry_out)
    wire carry_add  = add_res[32];
    wire carry_addu = addu_res[32];
    wire carry_sub  = ~sub_res[32];
    wire carry_subu = ~subu_res[32];

    assign carry = (aluc == ADD)  ? carry_add  :
                   (aluc == ADDU) ? carry_addu :
                   (aluc == SUB)  ? carry_sub  :
                   (aluc == SUBU) ? carry_subu :
                                   1'b0;

    // Overflow detection for signed add and sub
    wire overflow_add = (~a[31] & ~b[31] & r_reg[31]) | (a[31] & b[31] & ~r_reg[31]);
    wire overflow_sub = (a[31] & ~b[31] & ~r_reg[31]) | (~a[31] & b[31] & r_reg[31]);

    assign overflow = (aluc == ADD) ? overflow_add :
                      (aluc == SUB) ? overflow_sub :
                                     1'b0;

    // zero flag
    assign zero = (r == 32'd0);

    // negative flag - MSB of result
    assign negative = r[31];

    // flag output
    // flag is 1 for SLT and SLTU; 'z' otherwise (high impedance)
    assign flag = (aluc == SLT || aluc == SLTU) ? 1'b1 : 1'bz;

endmodule