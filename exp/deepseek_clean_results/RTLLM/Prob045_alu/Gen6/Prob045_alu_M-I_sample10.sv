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
    wire [4:0] shift_amount = (aluc == SLLV || aluc == SRLV || aluc == SRAV) ? a[4:0] : b[4:0];
    
    // Operation enables
    wire arith_en = (aluc == ADD || aluc == ADDU || aluc == SUB || aluc == SUBU);
    wire logic_en = (aluc == AND || aluc == OR || aluc == XOR || aluc == NOR);
    wire shift_en = (aluc == SLL || aluc == SRL || aluc == SRA || 
                    aluc == SLLV || aluc == SRLV || aluc == SRAV);
    wire comp_en = (aluc == SLT || aluc == SLTU);
    
    // Arithmetic operations (gated)
    wire [31:0] add_result, sub_result;
    wire add_ovf, sub_ovf, add_carry, sub_carry;
    
    assign {add_carry, add_result} = arith_en ? (a + b) : {1'b0, 32'b0};
    assign {sub_carry, sub_result} = arith_en ? (a - b) : {1'b0, 32'b0};
    
    // Overflow detection
    assign add_ovf = (aluc == ADD) && (a[31] == b[31]) && (add_result[31] != a[31]);
    assign sub_ovf = (aluc == SUB) && (a[31] != b[31]) && (sub_result[31] != a[31]);
    
    // Logic operations (gated)
    wire [31:0] and_result = logic_en ? (a & b) : 32'b0;
    wire [31:0] or_result  = logic_en ? (a | b) : 32'b0;
    wire [31:0] xor_result = logic_en ? (a ^ b) : 32'b0;
    wire [31:0] nor_result = logic_en ? ~(a | b) : 32'b0;
    
    // Comparison operations (gated)
    wire slt_res = comp_en & (signed_a < signed_b);
    wire sltu_res = comp_en & (a < b);
    wire [31:0] comp_result = {31'b0, (aluc == SLT) ? slt_res : sltu_res};
    
    // Unified shifter
    reg [31:0] shift_result;
    always @(*) begin
        if (shift_en) begin
            case (aluc)
                SLL, SLLV: shift_result = b << shift_amount;
                SRL, SRLV: shift_result = b >> shift_amount;
                SRA, SRAV: shift_result = $signed(b) >>> shift_amount;
                default: shift_result = 32'b0;
            endcase
        end
        else shift_result = 32'b0;
    end
    
    // LUI operation
    wire [31:0] lui_result = (aluc == LUI) ? {b[15:0], 16'b0} : 32'b0;
    
    // Result selection
    reg [31:0] result;
    always @(*) begin
        case (aluc)
            ADD, ADDU: result = add_result;
            SUB, SUBU: result = sub_result;
            AND:      result = and_result;
            OR:       result = or_result;
            XOR:      result = xor_result;
            NOR:      result = nor_result;
            SLT, SLTU: result = comp_result;
            SLL, SLLV, SRL, SRLV, SRA, SRAV: result = shift_result;
            LUI:      result = lui_result;
            default:  result = 32'b0;
        endcase
    end
    
    // Output assignments
    assign r = result;
    assign zero = (result == 32'b0);
    assign negative = result[31];
    assign overflow = add_ovf | sub_ovf;
    assign carry = (aluc == ADD || aluc == ADDU) ? add_carry : 
                 ((aluc == SUB || aluc == SUBU) ? sub_carry : 1'b0);
    assign flag = (aluc == SLT) ? slt_res : 
                ((aluc == SLTU) ? sltu_res : 1'b0);

endmodule