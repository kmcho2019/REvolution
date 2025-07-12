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

    // Shared resources
    wire [32:0] sum = {1'b0, a} + {1'b0, b};
    wire [32:0] diff = {1'b0, a} - {1'b0, b};
    wire [4:0] shamt = (aluc == SLLV || aluc == SRLV || aluc == SRAV) ? a[4:0] : b[4:0];
    wire a_msb = a[31];
    wire b_msb = b[31];
    wire r_msb;

    always @(*) begin
        case (aluc)
            ADD, ADDU: r = sum[31:0];
            SUB, SUBU: r = diff[31:0];
            AND:       r = a & b;
            OR:        r = a | b;
            XOR:       r = a ^ b;
            NOR:       r = ~(a | b);
            SLT:       r = $signed(a) < $signed(b);
            SLTU:      r = a < b;
            SLL, SLLV: r = b << shamt;
            SRL, SRLV: r = b >> shamt;
            SRA, SRAV: r = $signed(b) >>> shamt;
            LUI:       r = {b[15:0], 16'b0};
            default:   r = 32'bz; // High-Z for invalid ops
        endcase
    end

    // Flag assignments
    assign r_msb = r[31];
    assign zero = (r == 0);
    assign carry = (aluc == ADD || aluc == ADDU) ? sum[32] :
                 (aluc == SUB || aluc == SUBU) ? diff[32] : 1'b0;
    assign negative = r_msb;
    assign overflow = (aluc == ADD && (a_msb == b_msb) && (r_msb != a_msb)) ||
                     (aluc == SUB && (a_msb != b_msb) && (r_msb != a_msb));
    assign flag = (aluc == SLT || aluc == SLTU) ? r[0] : 1'b0;

endmodule