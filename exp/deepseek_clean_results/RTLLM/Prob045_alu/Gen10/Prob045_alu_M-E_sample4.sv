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

    // Operation classification
    wire is_add  = (aluc == ADD || aluc == ADDU);
    wire is_sub  = (aluc == SUB || aluc == SUBU);
    wire is_arith = is_add | is_sub;
    wire is_logic = (aluc == AND || aluc == OR || aluc == XOR || aluc == NOR);
    wire is_shift = (aluc == SLL || aluc == SRL || aluc == SRA || 
                    aluc == SLLV || aluc == SRLV || aluc == SRAV);
    wire is_comp = (aluc == SLT || aluc == SLTU);
    wire is_lui = (aluc == LUI);

    // Early flag prediction (speculative)
    wire [32:0] add_pred = {1'b0,a} + {1'b0,b};
    wire [32:0] sub_pred = {1'b0,a} - {1'b0,b};
    wire pred_carry = is_add ? add_pred[32] : is_sub ? sub_pred[32] : 1'b0;
    wire pred_overflow = (is_add & (aluc == ADD)) ? 
                        (~a[31] & ~b[31] & add_pred[31]) | (a[31] & b[31] & ~add_pred[31]) :
                        (is_sub & (aluc == SUB)) ?
                        (~a[31] & b[31] & sub_pred[31]) | (a[31] & ~b[31] & ~sub_pred[31]) : 1'b0;

    // Shared arithmetic results
    wire [31:0] arith_result = is_add ? add_pred[31:0] : sub_pred[31:0];

    // Barrel shifter implementation
    wire [4:0] shift_amt = (aluc[3]) ? a[4:0] : b[4:0]; // SxLV vs Sx
    wire [31:0] shift_in = (aluc[1:0] == 2'b11) ? $signed(b) : b; // SRA/SRAV
    wire [31:0] shifted_val = (aluc[0]) ? (shift_in >>> shift_amt) : // SRA/SRAV
                             (aluc[1]) ? (b >> shift_amt) : // SRL/SRLV
                             (b << shift_amt); // SLL/SLLV

    // Comparison logic
    wire signed [31:0] a_signed = a;
    wire signed [31:0] b_signed = b;
    wire comp_result = (aluc == SLT) ? (a_signed < b_signed) : (a < b);

    // Zero detection tree (parallel)
    wire [15:0] z_low = r[15:0] | r[31:16];
    wire [7:0] z_mid = z_low[7:0] | z_low[15:8];
    wire [3:0] z_high = z_mid[3:0] | z_mid[7:4];
    wire z_final = z_high[0] | z_high[1] | z_high[2] | z_high[3];

    // Result selection
    always @(*) begin
        case (1'b1)
            is_arith: r = arith_result;
            is_logic: begin
                case (aluc)
                    AND: r = a & b;
                    OR:  r = a | b;
                    XOR: r = a ^ b;
                    NOR: r = ~(a | b);
                    default: r = 32'b0;
                endcase
            end
            is_shift: r = shifted_val;
            is_comp: r = {31'b0, comp_result};
            is_lui: r = {b[15:0], 16'b0};
            default: r = 32'b0;
        endcase

        // Flag updates
        zero = ~|r; // Optimized zero detection
        carry = pred_carry;
        negative = r[31];
        overflow = pred_overflow;
        flag = is_comp ? comp_result : 1'b0;
    end

endmodule