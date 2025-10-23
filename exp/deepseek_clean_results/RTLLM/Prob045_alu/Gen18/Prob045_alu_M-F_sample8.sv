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

    // Internal signals
    wire [31:0] add_res = a + b;
    wire [31:0] sub_res = a - b;
    wire add_carry = (a + b) >> 32;
    wire sub_carry = (a - b) >> 32;
    wire [4:0] shift_amt = (aluc[3]) ? a[4:0] : b[4:0]; // SLLV/SRLV/SRAV use a[4:0]
    
    // Operation enable signals
    wire arith_en = (aluc == ADD) || (aluc == ADDU) || (aluc == SUB) || (aluc == SUBU);
    wire logic_en = (aluc == AND) || (aluc == OR) || (aluc == XOR) || (aluc == NOR);
    wire shift_en = (aluc == SLL) || (aluc == SRL) || (aluc == SRA) || 
                   (aluc == SLLV) || (aluc == SRLV) || (aluc == SRAV);
    wire comp_en = (aluc == SLT) || (aluc == SLTU);
    
    // Flag outputs
    assign zero = (r == 32'b0);
    assign carry = arith_en ? ((aluc[0] ? add_carry : sub_carry) : 1'b0);
    assign negative = r[31];
    assign overflow = ((aluc == ADD) && (a[31] == b[31]) && (r[31] != a[31])) ||
                     ((aluc == SUB) && (a[31] != b[31]) && (r[31] != a[31]));

    // Default flag assignment (overridden for SLT/SLTU)
    always @(*) flag = 1'b0;

    // Main operation selection
    always @(*) begin
        case (aluc)
            ADD, ADDU: r = add_res;
            SUB, SUBU: r = sub_res;
            AND:      r = a & b;
            OR:       r = a | b;
            XOR:      r = a ^ b;
            NOR:      r = ~(a | b);
            SLT:      begin r = ($signed(a) < $signed(b)) ? 32'b1 : 32'b0; flag = r[0]; end
            SLTU:     begin r = (a < b) ? 32'b1 : 32'b0; flag = r[0]; end
            SLL, SLLV: r = b << shift_amt;
            SRL, SRLV: r = b >> shift_amt;
            SRA, SRAV: r = $signed(b) >>> shift_amt;
            LUI:      r = {b[15:0], 16'b0};
            default:  r = 32'b0;
        endcase
    end

endmodule