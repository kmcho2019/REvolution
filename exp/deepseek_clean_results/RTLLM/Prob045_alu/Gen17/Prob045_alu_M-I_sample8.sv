module alu(
    input [31:0] a,
    input [31:0] b,
    input [5:0] aluc,
    output reg [31:0] r,
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

    // Operation classification
    wire is_arith = (aluc == ADD || aluc == ADDU || aluc == SUB || aluc == SUBU);
    wire is_shift = (aluc == SLL || aluc == SRL || aluc == SRA || 
                    aluc == SLLV || aluc == SRLV || aluc == SRAV);
    wire is_compare = (aluc == SLT || aluc == SLTU);
    
    // Shared resources with gating
    wire [4:0] shamt = (aluc[3]) ? a[4:0] : b[4:0]; // SLLV/SRLV/SRAV use a[4:0]
    
    // Arithmetic units with operation gating
    wire [32:0] sum = is_arith ? {1'b0, a} + {1'b0, b} : 33'b0;
    wire [32:0] diff = is_arith ? {1'b0, a} - {1'b0, b} : 33'b0;
    
    // Comparison logic (shared between SLT/SLTU)
    wire signed_lt = $signed(a) < $signed(b);
    wire unsigned_lt = a < b;
    
    // Overflow detection
    wire a_msb = a[31];
    wire b_msb = b[31];
    wire r_msb;
    wire add_ovf = (a_msb == b_msb) && (r_msb != a_msb);
    wire sub_ovf = (a_msb != b_msb) && (r_msb != a_msb);
    
    always @(*) begin
        case (aluc)
            ADD, ADDU: r = sum[31:0];
            SUB, SUBU: r = diff[31:0];
            AND:      r = a & b;
            OR:       r = a | b;
            XOR:      r = a ^ b;
            NOR:     r = ~(a | b);
            SLT:     r = {31'b0, signed_lt};
            SLTU:    r = {31'b0, unsigned_lt};
            SLL, SLLV: r = b << shamt;
            SRL, SRLV: r = b >> shamt;
            SRA, SRAV: r = $signed(b) >>> shamt;
            LUI:     r = {b[15:0], 16'b0};
            default: r = 32'bz;
        endcase
    end

    // Flag assignments
    assign r_msb = r[31];
    assign zero = (r == 0);
    assign carry = (aluc == ADD || aluc == ADDU) ? sum[32] :
                  (aluc == SUB || aluc == SUBU) ? diff[32] : 1'b0;
    assign negative = r_msb;
    assign overflow = (aluc == ADD) ? add_ovf :
                     (aluc == SUB) ? sub_ovf : 1'b0;
    assign flag = is_compare ? r[0] : 1'b0;

endmodule