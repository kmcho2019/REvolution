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

    wire signed [31:0] signed_a = a;
    wire signed [31:0] signed_b = b;
    wire [31:0] shamt = (aluc[3] ? a[4:0] : b[4:0]); // Shift amount
    
    // Arithmetic operations
    wire [32:0] add_res = {1'b0, a} + {1'b0, b};
    wire [32:0] sub_res = {1'b0, a} - {1'b0, b};
    wire [32:0] addu_res = a + b;
    wire [32:0] subu_res = a - b;
    
    // Logic operations
    wire [31:0] and_res = a & b;
    wire [31:0] or_res = a | b;
    wire [31:0] xor_res = a ^ b;
    wire [31:0] nor_res = ~(a | b);
    
    // Comparison operations
    wire slt_res = signed_a < signed_b;
    wire sltu_res = a < b;
    
    // Shift operations
    wire [31:0] shift_in = (aluc[3] ? a : b); // SLLV/SRLV/SRAV use a as input
    wire [31:0] sll_res = shift_in << shamt;
    wire [31:0] srl_res = shift_in >> shamt;
    wire [31:0] sra_res = $signed(shift_in) >>> shamt;
    
    // LUI operation
    wire [31:0] lui_res = {b[15:0], 16'b0};
    
    // Result selection
    assign r = 
        (aluc == ADD || aluc == ADDU) ? add_res[31:0] :
        (aluc == SUB || aluc == SUBU) ? sub_res[31:0] :
        (aluc == AND) ? and_res :
        (aluc == OR)  ? or_res :
        (aluc == XOR) ? xor_res :
        (aluc == NOR) ? nor_res :
        (aluc == SLT || aluc == SLTU) ? {31'b0, flag} :
        (aluc == SLL || aluc == SLLV) ? sll_res :
        (aluc == SRL || aluc == SRLV) ? srl_res :
        (aluc == SRA || aluc == SRAV) ? sra_res :
        (aluc == LUI) ? lui_res : 32'b0;
    
    // Flag assignments
    assign flag = (aluc == SLT) ? slt_res : 
                 (aluc == SLTU) ? sltu_res : 1'bz;
    
    assign zero = (r == 32'b0);
    assign negative = r[31];
    assign carry = (aluc == ADD || aluc == ADDU) ? add_res[32] :
                  (aluc == SUB || aluc == SUBU) ? sub_res[32] : 1'b0;
    
    // Overflow detection function
    function automatic ovf_detect;
        input [5:0] op;
        input [31:0] a, b, res;
        begin
            case (op)
                ADD: ovf_detect = (a[31] == b[31]) && (res[31] != a[31]);
                SUB: ovf_detect = (a[31] != b[31]) && (res[31] != a[31]);
                default: ovf_detect = 1'b0;
            endcase
        end
    endfunction
    
    assign overflow = ovf_detect(aluc, a, b, r);

endmodule