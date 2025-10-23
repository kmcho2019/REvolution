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

    wire signed [31:0] signed_a = a;
    wire signed [31:0] signed_b = b;
    wire [4:0] shift_amount = aluc[3] ? a[4:0] : b[4:0];
    
    // Arithmetic operations
    wire do_arith = (aluc == ADD || aluc == ADDU || aluc == SUB || aluc == SUBU);
    wire is_sub = (aluc == SUB || aluc == SUBU);
    wire [31:0] b_arith = is_sub ? ~b : b;
    wire cin = is_sub;
    
    wire [32:0] arith_res;
    assign arith_res = {1'b0, a} + {1'b0, b_arith} + {32'b0, cin};
    
    // Shared barrel shifter
    wire [31:0] shift_res;
    barrel_shifter shifter(
        .data(b),
        .shift(shift_amount),
        .mode(aluc[1:0]),
        .result(shift_res)
    );
    
    // Comparison logic
    wire comp_res = (aluc == SLT) ? (signed_a < signed_b) : (a < b);
    
    // Logic operations
    wire [31:0] logic_res = 
        (aluc == AND) ? (a & b) :
        (aluc == OR)  ? (a | b) :
        (aluc == XOR) ? (a ^ b) :
        (aluc == NOR) ? ~(a | b) :
        32'b0;
    
    // Result selection
    assign r = 
        do_arith ? arith_res[31:0] :
        (aluc == AND || aluc == OR || aluc == XOR || aluc == NOR) ? logic_res :
        (aluc == SLT || aluc == SLTU) ? {31'b0, comp_res} :
        (aluc == SLL || aluc == SRL || aluc == SRA) ? shift_res :
        (aluc == LUI) ? {b[15:0], 16'b0} :
        32'b0;
    
    // Status flags
    assign zero = ~|r;
    assign carry = do_arith ? arith_res[32] : 1'b0;
    assign negative = r[31];
    assign overflow = do_arith && 
        ((aluc == ADD && (a[31] == b[31]) && (r[31] != a[31])) ||
        (aluc == SUB && (a[31] != b[31]) && (r[31] != a[31]));
    assign flag = (aluc == SLT || aluc == SLTU) ? comp_res : 1'b0;

endmodule

// Barrel shifter module (unchanged)
module barrel_shifter(
    input [31:0] data,
    input [4:0] shift,
    input [1:0] mode,
    output reg [31:0] result
);
    always @(*) begin
        case (mode)
            2'b00: result = data << shift; // SLL
            2'b10: result = data >> shift; // SRL
            2'b11: result = $signed(data) >>> shift; // SRA
            default: result = data;
        endcase
    end
endmodule