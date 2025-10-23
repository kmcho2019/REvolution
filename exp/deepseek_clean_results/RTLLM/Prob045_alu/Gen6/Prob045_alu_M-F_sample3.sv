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
    wire [31:0] b_shifted;
    
    // Configurable shifter
    assign b_shifted = (aluc == SLL || aluc == SLLV) ? b << shift_amount :
                      (aluc == SRL || aluc == SRLV) ? b >> shift_amount :
                      $signed(b) >>> shift_amount;

    // Arithmetic operations (computed only when needed)
    wire [31:0] add_result;
    wire [31:0] sub_result;
    wire add_carry, sub_carry;
    wire add_ovf, sub_ovf;
    
    assign {add_carry, add_result} = {1'b0, a} + {1'b0, b};
    assign {sub_carry, sub_result} = {1'b0, a} + {1'b0, ~b} + 33'b1;
    
    // Overflow detection
    assign add_ovf = (a[31] == b[31]) && (add_result[31] != a[31]);
    assign sub_ovf = (a[31] != b[31]) && (sub_result[31] != a[31]);
    
    // Comparison results (shared for SLT/SLTU and flag)
    wire slt_res = signed_a < signed_b;
    wire sltu_res = a < b;
    
    // Main result selection
    reg [31:0] res;
    always @(*) begin
        case (aluc)
            ADD, ADDU: res = add_result;
            SUB, SUBU: res = sub_result;
            AND: res = a & b;
            OR:  res = a | b;
            XOR: res = a ^ b;
            NOR: res = ~(a | b);
            SLT: res = {31'b0, slt_res};
            SLTU: res = {31'b0, sltu_res};
            SLL, SLLV, SRL, SRLV, SRA, SRAV: res = b_shifted;
            LUI: res = {b[15:0], 16'b0};
            default: res = 32'b0;
        endcase
    end
    
    // Output assignments
    assign r = res;
    assign zero = (res == 32'b0);
    assign negative = res[31];
    assign overflow = (aluc == ADD) ? add_ovf : 
                     (aluc == SUB) ? sub_ovf : 1'b0;
    assign carry = (aluc == ADD || aluc == ADDU) ? add_carry : 
                  (aluc == SUB || aluc == SUBU) ? sub_carry : 1'b0;
    assign flag = (aluc == SLT) ? slt_res :
                 (aluc == SLTU) ? sltu_res : 1'b0;

endmodule