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

    // Operation codes
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

    // Pipeline registers
    reg [31:0] stage1_result;
    reg [4:0] stage1_flags; // {zero, carry, negative, overflow, flag}

    // Parallel datapaths
    wire [31:0] arith_result;
    wire [31:0] logic_result;
    wire [31:0] shift_result;
    wire [31:0] cmp_result;
    wire [31:0] lui_result;

    // Arithmetic Unit (with early flag prediction)
    wire [32:0] add_result = {1'b0, a} + {1'b0, b};
    wire [32:0] sub_result = {1'b0, a} - {1'b0, b};
    wire arith_ovf_add = (a[31] == b[31]) && (add_result[31] != a[31]);
    wire arith_ovf_sub = (a[31] != b[31]) && (sub_result[31] != a[31]);
    
    assign arith_result = 
        (aluc == ADD || aluc == ADDU) ? add_result[31:0] :
        (aluc == SUB || aluc == SUBU) ? sub_result[31:0] : 32'b0;

    // Logic Unit
    assign logic_result = 
        (aluc == AND) ? a & b :
        (aluc == OR)  ? a | b :
        (aluc == XOR) ? a ^ b :
        (aluc == NOR) ? ~(a | b) : 32'b0;

    // Shift Unit (barrel shifter with mask control)
    wire [4:0] shift_amount = 
        (aluc == SLLV || aluc == SRLV || aluc == SRAV) ? a[4:0] : b[4:0];
    
    assign shift_result = 
        (aluc == SLL || aluc == SLLV) ? b << shift_amount :
        (aluc == SRL || aluc == SRLV) ? b >> shift_amount :
        (aluc == SRA || aluc == SRAV) ? $signed(b) >>> shift_amount : 32'b0;

    // Comparison Unit (shared for SLT/SLTU)
    wire signed [31:0] signed_a = a;
    wire signed [31:0] signed_b = b;
    wire cmp_out = 
        (aluc == SLT)  ? (signed_a < signed_b) :
        (aluc == SLTU) ? (a < b) : 1'b0;
    assign cmp_result = {31'b0, cmp_out};

    // LUI Unit
    assign lui_result = {b[15:0], 16'b0};

    // Early zero detection (parallel OR reduction)
    wire [31:0] pre_result;
    assign pre_result = 
        (aluc[5:4] == 2'b10 && !aluc[3]) ? arith_result : // Arithmetic
        (aluc[5:4] == 2'b10 && aluc[3]) ? logic_result :  // Logical
        (aluc[5:4] == 2'b00) ? shift_result :             // Shift
        (aluc == LUI) ? lui_result :                       // LUI
        cmp_result;                                        // Comparison

    wire pre_zero = (pre_result == 32'b0);
    wire pre_negative = pre_result[31];

    // First pipeline stage
    always @(*) begin
        stage1_result = pre_result;
        stage1_flags[4] = pre_zero;
        stage1_flags[3] = (aluc == ADD) ? add_result[32] : 
                         ((aluc == SUB) ? sub_result[32] : 1'b0);
        stage1_flags[2] = pre_negative;
        stage1_flags[1] = (aluc == ADD) ? arith_ovf_add : 
                         ((aluc == SUB) ? arith_ovf_sub : 1'b0);
        stage1_flags[0] = cmp_out;
    end

    // Second pipeline stage (output registers)
    always @(*) begin
        r = stage1_result;
        zero = stage1_flags[4];
        carry = stage1_flags[3];
        negative = stage1_flags[2];
        overflow = stage1_flags[1];
        flag = (aluc == SLT || aluc == SLTU) ? stage1_flags[0] : 1'b0;
    end

endmodule