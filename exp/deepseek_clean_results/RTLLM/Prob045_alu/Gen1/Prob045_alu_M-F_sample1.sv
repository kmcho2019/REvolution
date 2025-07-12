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

    wire signed [31:0] sa = a;
    wire signed [31:0] sb = b;
    reg [32:0] arith_res;  // For arithmetic operations
    reg [31:0] logic_res;  // For logical operations
    reg [31:0] shift_res;  // For shift operations
    wire [4:0] shift_amt = (aluc == SLLV || aluc == SRLV || aluc == SRAV) ? a[4:0] : b[4:0];

    // Unified barrel shifter
    always @(*) begin
        case (aluc)
            SLL, SLLV: shift_res = b << shift_amt;
            SRL, SRLV: shift_res = b >> shift_amt;
            SRA, SRAV: shift_res = $signed(b) >>> shift_amt;
            default: shift_res = 32'b0;
        endcase
    end

    // Arithmetic operations
    always @(*) begin
        arith_res = 33'b0;
        case (aluc)
            ADD:  arith_res = sa + sb;
            ADDU: arith_res = a + b;
            SUB:  arith_res = sa - sb;
            SUBU: arith_res = a - b;
            default: arith_res = 33'b0;
        endcase
    end

    // Logical operations
    always @(*) begin
        logic_res = 32'b0;
        case (aluc)
            AND:  logic_res = a & b;
            OR:   logic_res = a | b;
            XOR:  logic_res = a ^ b;
            NOR:  logic_res = ~(a | b);
            LUI:  logic_res = {b[15:0], 16'b0};
            default: logic_res = 32'b0;
        endcase
    end

    // Result selection and flag generation
    always @(*) begin
        flag = 1'b0;
        r = 32'b0;
        
        case (aluc)
            ADD, ADDU, SUB, SUBU: begin
                r = arith_res[31:0];
            end
            AND, OR, XOR, NOR, LUI: begin
                r = logic_res;
            end
            SLL, SRL, SRA, SLLV, SRLV, SRAV: begin
                r = shift_res;
            end
            SLT: begin
                r = (sa < sb) ? 32'b1 : 32'b0;
                flag = r[0];
            end
            SLTU: begin
                r = (a < b) ? 32'b1 : 32'b0;
                flag = r[0];
            end
            default: r = 32'b0;
        endcase
    end

    // Status flags
    assign zero = (r == 32'b0);
    assign negative = r[31];
    assign carry = arith_res[32];
    assign overflow = (aluc == ADD) ? (sa[31] == sb[31] && r[31] != sa[31]) :
                     (aluc == SUB) ? (sa[31] != sb[31] && r[31] != sa[31]) : 1'b0;

endmodule