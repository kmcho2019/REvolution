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
    wire slt_res = signed_a < signed_b;
    wire sltu_res = a < b;
    wire [4:0] shift_amount = aluc[3] ? a[4:0] : b[4:0];
    
    // Arithmetic results
    wire [31:0] add_sub_result = (aluc == ADD || aluc == ADDU) ? add_res[31:0] :
                                (aluc == SUB || aluc == SUBU) ? sub_res[31:0] : 32'b0;
    
    // Logical results
    wire [31:0] logical_result = (aluc == AND) ? (a & b) :
                                (aluc == OR)  ? (a | b) :
                                (aluc == XOR) ? (a ^ b) :
                                (aluc == NOR) ? ~(a | b) : 32'b0;
    
    // Shift results
    wire [31:0] shift_result = (aluc == SLL)  ? (b << a[4:0]) :
                              (aluc == SRL)  ? (b >> a[4:0]) :
                              (aluc == SRA)  ? (signed_b >>> a[4:0]) :
                              (aluc == SLLV) ? (b << shift_amount) :
                              (aluc == SRLV) ? (b >> shift_amount) :
                              (aluc == SRAV) ? (signed_b >>> shift_amount) : 32'b0;
    
    // Comparison results
    wire [31:0] compare_result = (aluc == SLT)  ? {31'b0, slt_res} :
                                (aluc == SLTU) ? {31'b0, sltu_res} : 32'b0;
    
    // LUI result
    wire [31:0] lui_result = (aluc == LUI) ? {b[15:0], 16'b0} : 32'b0;
    
    // Final result selection
    assign r = (aluc == ADD || aluc == ADDU || aluc == SUB || aluc == SUBU) ? add_sub_result :
              (aluc == AND || aluc == OR || aluc == XOR || aluc == NOR) ? logical_result :
              (aluc == SLT || aluc == SLTU) ? compare_result :
              (aluc == SLL || aluc == SRL || aluc == SRA || 
               aluc == SLLV || aluc == SRLV || aluc == SRAV) ? shift_result :
              (aluc == LUI) ? lui_result : 32'b0;
    
    // Flag generation
    assign zero = (r == 32'b0);
    assign negative = r[31];
    assign carry = (aluc == ADD || aluc == ADDU) ? add_res[32] : 
                 (aluc == SUB || aluc == SUBU) ? sub_res[32] : 1'b0;
    assign overflow = (aluc == ADD && (a[31] == b[31]) && (r[31] != a[31])) ||
                    (aluc == SUB && (a[31] != b[31]) && (r[31] != a[31]));
    assign flag = (aluc == SLT) ? slt_res :
                 (aluc == SLTU) ? sltu_res : 1'b0;

endmodule