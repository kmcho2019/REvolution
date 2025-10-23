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

    // Opcode parameters encapsulated locally
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

    // Predecode operation groups for efficient gating and muxing
    wire op_add   = (aluc == ADD);
    wire op_addu  = (aluc == ADDU);
    wire op_sub   = (aluc == SUB);
    wire op_subu  = (aluc == SUBU);
    wire op_and   = (aluc == AND);
    wire op_or    = (aluc == OR);
    wire op_xor   = (aluc == XOR);
    wire op_nor   = (aluc == NOR);
    wire op_slt   = (aluc == SLT);
    wire op_sltu  = (aluc == SLTU);
    wire op_sll   = (aluc == SLL);
    wire op_srl   = (aluc == SRL);
    wire op_sra   = (aluc == SRA);
    wire op_sllv  = (aluc == SLLV);
    wire op_srlv  = (aluc == SRLV);
    wire op_srav  = (aluc == SRAV);
    wire op_lui   = (aluc == LUI);

    // Signed casts for arithmetic and comparisons
    wire signed [31:0] a_s = $signed(a);
    wire signed [31:0] b_s = $signed(b);

    // Unified shift amount extraction (5 bits from a)
    wire [4:0] shamt = a[4:0];

    // 33-bit extended add and sub for carry detection
    wire [32:0] add_ext = {1'b0, a} + {1'b0, b};
    wire [32:0] sub_ext = {1'b0, a} - {1'b0, b};

    // Arithmetic results (32-bit)
    wire [31:0] add_res  = add_ext[31:0];
    wire [31:0] addu_res = add_ext[31:0];  // Same as add_res for unsigned
    wire [31:0] sub_res  = sub_ext[31:0];
    wire [31:0] subu_res = sub_ext[31:0];  // Same as sub_res for unsigned

    // Carry flags:
    // For ADD and ADDU, carry if MSB of extended addition is 1.
    // For SUB and SUBU, borrow is indicated if MSB is 0 (borrow occurred if carry bit cleared)
    // According to MIPS convention, carry for subtraction means borrow == ~carry.
    wire carry_add  = add_ext[32];
    wire carry_sub  = sub_ext[32];
    // Carry output set true if ADD/ADDU carry=1 or SUB/SUBU borrow (carry=0) means carry=~carry_sub
    wire carry_out = (op_add  && carry_add)  ||
                     (op_addu && carry_add)  ||
                     (op_sub  && ~carry_sub) ||
                     (op_subu && ~carry_sub);

    // Overflow detection for signed add and sub only
    // Add overflow: if sign of a and b are same but sign of result differs
    wire overflow_add = (~a[31] & ~b[31] & add_res[31]) | (a[31] & b[31] & ~add_res[31]);
    // Sub overflow: if signs of a and b differ and sign of result differs from sign of a
    wire overflow_sub = (a[31] & ~b[31] & ~sub_res[31]) | (~a[31] & b[31] & sub_res[31]);
    wire overflow_out = (op_add ? overflow_add :
                         op_sub ? overflow_sub :
                         1'b0);

    // Logical operations
    wire [31:0] logic_res = (op_and) ? (a & b) :
                           (op_or)  ? (a | b) :
                           (op_xor) ? (a ^ b) :
                           (op_nor) ? ~(a | b) :
                           32'b0;

    // Shift operations
    wire [31:0] shift_res = (op_sll)  ? (b << shamt) :
                            (op_srl)  ? (b >> shamt) :
                            (op_sra)  ? ($signed(b_s) >>> shamt) :
                            (op_sllv) ? (b << shamt) :
                            (op_srlv) ? (b >> shamt) :
                            (op_srav) ? ($signed(b_s) >>> shamt) :
                            32'b0;

    // SLT and SLTU flags and result
    wire slt_flag_val  = (a_s < b_s);
    wire sltu_flag_val = (a < b);
    wire [31:0] slt_res  = {31'd0, slt_flag_val};
    wire [31:0] sltu_res = {31'd0, sltu_flag_val};

    // LUI operation: upper immediate load, a[15:0]<<16
    wire [31:0] lui_res = {a[15:0], 16'b0};

    // Result multiplexer - select result based on opcode
    wire [31:0] alu_res = (op_add  ? add_res  :
                          op_addu ? addu_res :
                          op_sub  ? sub_res  :
                          op_subu ? subu_res :
                          (op_and || op_or || op_xor || op_nor) ? logic_res :
                          (op_slt)  ? slt_res  :
                          (op_sltu) ? sltu_res :
                          (op_sll || op_srl || op_sra || op_sllv || op_srlv || op_srav) ? shift_res :
                          op_lui ? lui_res :
                          32'b0);

    // Flag output only meaningful for SLT and SLTU; else forced 0 for power and glitch reduction
    wire flag_out = (op_slt)  ? slt_flag_val :
                    (op_sltu) ? sltu_flag_val :
                    1'b0;

    // Zero flag is asserted when alu_res is zero
    wire zero_out = (alu_res == 32'b0);

    // Negative flag derived from MSB of alu_res
    wire negative_out = alu_res[31];

    // Assign outputs
    assign r = alu_res;
    assign zero = zero_out;
    assign carry = carry_out;
    assign negative = negative_out;
    assign overflow = overflow_out;
    assign flag = flag_out;

endmodule