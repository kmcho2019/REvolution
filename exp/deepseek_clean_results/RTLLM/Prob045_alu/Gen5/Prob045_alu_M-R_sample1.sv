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

    // Internal signals
    wire signed [31:0] signed_a = a;
    wire signed [31:0] signed_b = b;
    wire [32:0] add_res = {1'b0, a} + {1'b0, b};
    wire [32:0] sub_res = {1'b0, a} + {1'b0, ~b} + 33'b1;
    wire [4:0] shift_amount = (aluc == SLLV || aluc == SRLV || aluc == SRAV) ? a[4:0] : b[4:0];
    
    // Precompute all possible results
    wire [31:0] add_result = add_res[31:0];
    wire [31:0] sub_result = sub_res[31:0];
    wire [31:0] and_result = a & b;
    wire [31:0] or_result = a | b;
    wire [31:0] xor_result = a ^ b;
    wire [31:0] nor_result = ~(a | b);
    wire [31:0] slt_result = {31'b0, signed_a < signed_b};
    wire [31:0] sltu_result = {31'b0, a < b};
    wire [31:0] sll_result = b << a[4:0];
    wire [31:0] srl_result = b >> a[4:0];
    wire [31:0] sra_result = $signed(b) >>> a[4:0];
    wire [31:0] sllv_result = b << shift_amount;
    wire [31:0] srlv_result = b >> shift_amount;
    wire [31:0] srav_result = $signed(b) >>> shift_amount;
    wire [31:0] lui_result = {b[15:0], 16'b0};

    // Result selection using conditional operator
    assign r = (aluc == ADD || aluc == ADDU) ? add_result :
              (aluc == SUB || aluc == SUBU) ? sub_result :
              (aluc == AND) ? and_result :
              (aluc == OR) ? or_result :
              (aluc == XOR) ? xor_result :
              (aluc == NOR) ? nor_result :
              (aluc == SLT) ? slt_result :
              (aluc == SLTU) ? sltu_result :
              (aluc == SLL) ? sll_result :
              (aluc == SRL) ? srl_result :
              (aluc == SRA) ? sra_result :
              (aluc == SLLV) ? sllv_result :
              (aluc == SRLV) ? srlv_result :
              (aluc == SRAV) ? srav_result :
              (aluc == LUI) ? lui_result :
              32'b0;

    // Flag assignments
    assign zero = (r == 32'b0);
    assign negative = r[31];
    assign overflow = ((aluc == ADD) && (a[31] == b[31]) && (r[31] != a[31])) ||
                     ((aluc == SUB) && (a[31] != b[31]) && (r[31] != a[31]));
    assign carry = (aluc == ADD || aluc == ADDU) ? add_res[32] : 
                  (aluc == SUB || aluc == SUBU) ? sub_res[32] : 1'b0;
    assign flag = (aluc == SLT) ? slt_result[0] :
                 (aluc == SLTU) ? sltu_result[0] : 1'b0;

endmodule