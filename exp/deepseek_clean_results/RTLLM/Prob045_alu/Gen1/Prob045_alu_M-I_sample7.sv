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

    wire signed [31:0] signed_a = a;
    wire signed [31:0] signed_b = b;
    wire [4:0] shift_amount = (aluc == SLLV || aluc == SRLV || aluc == SRAV) ? a[4:0] : b[4:0];
    
    // Arithmetic results
    reg [32:0] arith_res;
    wire add_ovf = (signed_a[31] == signed_b[31]) && (arith_res[31] != signed_a[31]);
    wire sub_ovf = (signed_a[31] != signed_b[31]) && (arith_res[31] != signed_a[31]);
    
    // Logical/shift results
    reg [31:0] logic_res;
    
    // Status flags
    assign zero = (r == 32'b0);
    assign carry = (aluc == ADD || aluc == ADDU || aluc == SUB || aluc == SUBU) ? arith_res[32] : 1'b0;
    assign negative = r[31];
    assign overflow = ((aluc == ADD) && add_ovf) || ((aluc == SUB) && sub_ovf);
    assign flag = (aluc == SLT) ? (signed_a < signed_b) :
                 (aluc == SLTU) ? (a < b) : 1'bz;

    // Arithmetic operations
    always @(*) begin
        case (aluc)
            ADD:  arith_res = {signed_a[31], signed_a} + {signed_b[31], signed_b};
            ADDU: arith_res = {1'b0, a} + {1'b0, b};
            SUB:  arith_res = {signed_a[31], signed_a} - {signed_b[31], signed_b};
            SUBU: arith_res = {1'b0, a} - {1'b0, b};
            default: arith_res = 33'b0;
        endcase
    end

    // Logical and shift operations
    always @(*) begin
        case (aluc)
            AND:  logic_res = a & b;
            OR:   logic_res = a | b;
            XOR:  logic_res = a ^ b;
            NOR:  logic_res = ~(a | b);
            SLL:  logic_res = b << shift_amount;
            SRL:  logic_res = b >> shift_amount;
            SRA:  logic_res = $signed(b) >>> shift_amount;
            LUI:  logic_res = {b[15:0], 16'b0};
            default: logic_res = 32'b0;
        endcase
    end

    // Output selection
    always @(*) begin
        case (aluc)
            ADD, ADDU, SUB, SUBU: r = arith_res[31:0];
            SLT:  r = {31'b0, signed_a < signed_b};
            SLTU: r = {31'b0, a < b};
            default: r = logic_res;
        endcase
    end

endmodule