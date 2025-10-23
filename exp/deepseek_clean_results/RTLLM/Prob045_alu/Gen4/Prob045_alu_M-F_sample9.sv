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
    wire [4:0] shift_amount = (aluc[3] ? a[4:0] : b[4:0]);
    
    // Conditional arithmetic operations
    wire do_arith = (aluc == ADD || aluc == ADDU || aluc == SUB || aluc == SUBU);
    wire [32:0] arith_res;
    wire arith_carry;
    
    // 4-bit carry-lookahead adder blocks
    generate
        genvar i;
        for (i = 0; i < 8; i = i + 1) begin : adder_block
            wire [3:0] a_seg = a[(i*4)+3:i*4];
            wire [3:0] b_seg = (aluc[1] ? ~b[(i*4)+3:i*4] : b[(i*4)+3:i*4]); // SUB/SUBU
            wire [3:0] sum;
            wire cout;
            
            cla_4bit adder(
                .a(a_seg),
                .b(b_seg),
                .cin((i == 0) ? aluc[1] : adder_block[i-1].cout), // SUB/SUBU sets cin
                .sum(sum),
                .cout(cout)
            );
            
            assign arith_res[(i*4)+3:i*4] = sum;
            assign adder_block[i].cout = cout;
        end
    endgenerate
    
    assign arith_res[32] = adder_block[7].cout;
    assign arith_carry = arith_res[32];
    
    // Shared barrel shifter
    wire [31:0] shift_res;
    barrel_shifter shifter(
        .data(b),
        .shift(shift_amount),
        .mode(aluc[1:0]), // 00:SLL, 10:SRL, 11:SRA
        .result(shift_res)
    );
    
    // Unified comparison logic
    wire comp_res = (aluc == SLT) ? (signed_a < signed_b) : (a < b);
    
    // Result selection
    wire [31:0] logic_res = 
        (aluc == AND) ? (a & b) :
        (aluc == OR)  ? (a | b) :
        (aluc == XOR) ? (a ^ b) :
        (aluc == NOR) ? ~(a | b) :
        32'b0;
    
    assign r = 
        (do_arith) ? arith_res[31:0] :
        (aluc == AND || aluc == OR || aluc == XOR || aluc == NOR) ? logic_res :
        (aluc == SLT || aluc == SLTU) ? {31'b0, comp_res} :
        (aluc == SLL || aluc == SRL || aluc == SRA) ? shift_res :
        (aluc == LUI) ? {b[15:0], 16'b0} :
        32'b0;
    
    // Optimized status flags
    assign zero = ~|r; // Reduction NOR
    assign carry = do_arith ? arith_carry : 1'b0;
    assign negative = r[31];
    assign overflow = do_arith && 
        ((aluc == ADD && (a[31] == b[31]) && (r[31] != a[31])) ||
         (aluc == SUB && (a[31] != b[31]) && (r[31] != a[31])));
    assign flag = (aluc == SLT || aluc == SLTU) ? comp_res : 1'b0;

endmodule

// 4-bit carry-lookahead adder module
module cla_4bit(
    input [3:0] a,
    input [3:0] b,
    input cin,
    output [3:0] sum,
    output cout
);
    wire [3:0] p = a ^ b;
    wire [3:0] g = a & b;
    
    wire [3:0] c;
    assign c[0] = cin;
    assign c[1] = g[0] | (p[0] & cin);
    assign c[2] = g[1] | (p[1] & g[0]) | (p[1] & p[0] & cin);
    assign c[3] = g[2] | (p[2] & g[1]) | (p[2] & p[1] & g[0]) | (p[2] & p[1] & p[0] & cin);
    assign cout = g[3] | (p[3] & g[2]) | (p[3] & p[2] & g[1]) | (p[3] & p[2] & p[1] & g[0]) | 
                 (p[3] & p[2] & p[1] & p[0] & cin);
    
    assign sum = p ^ c;
endmodule

// Shared barrel shifter module
module barrel_shifter(
    input [31:0] data,
    input [4:0] shift,
    input [1:0] mode, // 00:SLL, 10:SRL, 11:SRA
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