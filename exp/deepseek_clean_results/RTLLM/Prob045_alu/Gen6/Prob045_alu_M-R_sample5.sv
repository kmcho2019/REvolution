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
    
    // Shift operation implementation
    wire [31:0] shift_in = b;
    wire [31:0] sll_result = shift_in << shift_amount;
    wire [31:0] srl_result = shift_in >> shift_amount;
    wire [31:0] sra_result = signed_b >>> shift_amount;
    
    // Operation result selection
    reg [31:0] result;
    always @(*) begin
        case (aluc)
            ADD, ADDU: result = add_res[31:0];
            SUB, SUBU: result = sub_res[31:0];
            AND:       result = a & b;
            OR:        result = a | b;
            XOR:       result = a ^ b;
            NOR:       result = ~(a | b);
            SLT:       result = {31'b0, slt_res};
            SLTU:      result = {31'b0, sltu_res};
            SLL:       result = b << a[4:0];
            SRL:       result = b >> a[4:0];
            SRA:       result = signed_b >>> a[4:0];
            SLLV:      result = sll_result;
            SRLV:      result = srl_result;
            SRAV:      result = sra_result;
            LUI:       result = {b[15:0], 16'b0};
            default:   result = 32'b0;
        endcase
    end
    
    // Flag generation
    assign r = result;
    assign zero = ~|result;  // Reduction OR for zero detection
    assign negative = result[31];
    assign carry = (aluc == ADD || aluc == ADDU) ? add_res[32] : 
                  (aluc == SUB || aluc == SUBU) ? sub_res[32] : 1'b0;
    
    // Overflow detection
    wire add_overflow = (a[31] == b[31]) && (result[31] != a[31]);
    wire sub_overflow = (a[31] != b[31]) && (result[31] != a[31]);
    assign overflow = (aluc == ADD) ? add_overflow :
                    (aluc == SUB) ? sub_overflow : 1'b0;
    
    // Flag output
    assign flag = (aluc == SLT) ? slt_res :
                 (aluc == SLTU) ? sltu_res : 1'b0;

endmodule