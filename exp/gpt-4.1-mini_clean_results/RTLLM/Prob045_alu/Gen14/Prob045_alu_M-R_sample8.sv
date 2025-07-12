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
    localparam ADD  = 6'b100000;
    localparam ADDU = 6'b100001;
    localparam SUB  = 6'b100010;
    localparam SUBU = 6'b100011;
    localparam AND  = 6'b100100;
    localparam OR   = 6'b100101;
    localparam XOR  = 6'b100110;
    localparam NOR  = 6'b100111;
    localparam SLT  = 6'b101010;
    localparam SLTU = 6'b101011;
    localparam SLL  = 6'b000000;
    localparam SRL  = 6'b000010;
    localparam SRA  = 6'b000011;
    localparam SLLV = 6'b000100;
    localparam SRLV = 6'b000110;
    localparam SRAV = 6'b000111;
    localparam LUI  = 6'b001111;

    // Unify shift amount (5 bits)
    wire [4:0] shamt = a[4:0];

    // Signed versions of inputs for arithmetic and comparisons
    wire signed [31:0] a_s = a;
    wire signed [31:0] b_s = b;

    // Arithmetic operation extended to 33 bits for carry/borrow detection
    wire [32:0] add_ext = {1'b0, a} + {1'b0, b};
    wire [32:0] sub_ext = {1'b0, a} - {1'b0, b};

    // Select arithmetic extended result based on aluc
    wire [32:0] arith_ext = 
        (aluc == ADD || aluc == ADDU) ? add_ext :
        (aluc == SUB || aluc == SUBU) ? sub_ext :
        33'd0;

    wire [31:0] arith_res = arith_ext[31:0];
    wire         arith_carry = arith_ext[32];

    // Overflow detection only for signed add and sub
    wire arith_overflow = (aluc == ADD)  ? 
                          (~a[31] & ~b[31] & arith_res[31]) | (a[31] & b[31] & ~arith_res[31]) :
                          (aluc == SUB) ?
                          (a[31] & ~b[31] & ~arith_res[31]) | (~a[31] & b[31] & arith_res[31]) :
                          1'b0;

    // Logical operations
    wire [31:0] logic_res =
        (aluc == AND) ? (a & b) :
        (aluc == OR)  ? (a | b) :
        (aluc == XOR) ? (a ^ b) :
        (aluc == NOR) ? ~(a | b) :
        32'd0;

    // Shift operations
    wire [31:0] shift_res =
        (aluc == SLL)  ? (b << shamt) :
        (aluc == SRL)  ? (b >> shamt) :
        (aluc == SRA)  ? ($signed(b) >>> shamt) :
        (aluc == SLLV) ? (b << shamt) :  // shamt reused for variable shifts
        (aluc == SRLV) ? (b >> shamt) :
        (aluc == SRAV) ? ($signed(b) >>> shamt) :
        32'd0;

    // SLT and SLTU flag and result
    wire slt_flag_val = (aluc == SLT)  ? (a_s < b_s) :
                        (aluc == SLTU) ? (a < b) :
                        1'b0;

    wire [31:0] slt_res = slt_flag_val ? 32'd1 : 32'd0;

    // LUI operation: load upper immediate (a[15:0]) << 16
    wire [31:0] lui_res = {a[15:0], 16'b0};

    // Result selection mux
    wire [31:0] alu_res = 
        (aluc == ADD || aluc == ADDU || aluc == SUB || aluc == SUBU) ? arith_res :
        (aluc == AND || aluc == OR || aluc == XOR || aluc == NOR) ? logic_res :
        (aluc == SLT || aluc == SLTU) ? slt_res :
        (aluc == SLL || aluc == SRL || aluc == SRA || aluc == SLLV || aluc == SRLV || aluc == SRAV) ? shift_res :
        (aluc == LUI) ? lui_res :
        32'd0;

    // Carry flag assigned only for ADD/ADDU/SUB/SUBU
    wire carry_val = ((aluc == ADD || aluc == ADDU) && arith_carry) ||
                     ((aluc == SUB || aluc == SUBU) && ~arith_carry) ? 1'b1 : 1'b0;

    // Flag output: only set for SLT/SLTU, else zero (not high-Z) for power saving
    wire flag_val = (aluc == SLT || aluc == SLTU) ? slt_flag_val : 1'b0;

    // Negative flag from MSB of result
    wire negative_val = alu_res[31];

    // Zero flag when result is zero
    wire zero_val = (alu_res == 32'd0);

    // Overflow only for signed ADD and SUB
    wire overflow_val = (aluc == ADD || aluc == SUB) ? arith_overflow : 1'b0;

    // Output assignments
    assign r = alu_res;
    assign carry = carry_val;
    assign overflow = overflow_val;
    assign negative = negative_val;
    assign zero = zero_val;
    assign flag = flag_val;

endmodule