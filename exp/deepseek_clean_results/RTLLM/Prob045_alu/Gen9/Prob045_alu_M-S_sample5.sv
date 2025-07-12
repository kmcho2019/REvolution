module alu(
    input [31:0] a,
    input [31:0] b,
    input [5:0] aluc,
    output reg [31:0] r,
    output zero,
    output carry,
    output negative,
    output overflow,
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

    wire signed [31:0] signed_a = a;
    wire signed [31:0] signed_b = b;
    wire [4:0] shift_amt = aluc[3] ? a[4:0] : b[4:0]; // For V-type shifts
    
    reg [32:0] arith_result; // 33-bit to capture carry
    wire sub_op = (aluc == SUB || aluc == SUBU);
    
    always @(*) begin
        case (aluc)
            ADD, ADDU, SUB, SUBU: begin
                arith_result = {1'b0, a} + {1'b0, sub_op ? ~b : b} + sub_op;
                r = arith_result[31:0];
                flag = 1'b0;
            end
            AND:  begin r = a & b; flag = 1'b0; end
            OR:   begin r = a | b; flag = 1'b0; end
            XOR:  begin r = a ^ b; flag = 1'b0; end
            NOR:  begin r = ~(a | b); flag = 1'b0; end
            SLT:  begin r = 0; flag = signed_a < signed_b; end
            SLTU: begin r = 0; flag = a < b; end
            SLL:  begin r = b << shift_amt; flag = 1'b0; end
            SRL:  begin r = b >> shift_amt; flag = 1'b0; end
            SRA:  begin r = signed_b >>> shift_amt; flag = 1'b0; end
            SLLV: begin r = b << a[4:0]; flag = 1'b0; end
            SRLV: begin r = b >> a[4:0]; flag = 1'b0; end
            SRAV: begin r = signed_b >>> a[4:0]; flag = 1'b0; end
            LUI:  begin r = {b[15:0], 16'b0}; flag = 1'b0; end
            default: begin r = 32'b0; flag = 1'b0; end
        endcase
    end

    // Flag generation
    assign zero = ~|r; // Reduction OR
    assign negative = r[31];
    assign carry = ((aluc == ADD) || (aluc == ADDU) || (aluc == SUB) || (aluc == SUBU)) ? 
                  arith_result[32] : 1'b0;
    
    // Overflow only for signed operations
    assign overflow = (~aluc[0] & (aluc == ADD || aluc == SUB)) ? 
                     (a[31] == (sub_op ? ~b[31] : b[31])) & (a[31] != r[31]) : 1'b0;

endmodule