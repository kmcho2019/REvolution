module alu(
    input [31:0] a,
    input [31:0] b,
    input [5:0] aluc,
    output reg [31:0] r,
    output zero,
    output reg carry,
    output negative,
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

    // Internal signals
    wire signed [31:0] signed_a = a;
    wire signed [31:0] signed_b = b;
    wire [4:0] shift_amount = (aluc[2:0] == 3'b100) ? a[4:0] : b[4:0];
    wire [31:0] b_operand = (aluc[0] ? ~b : b); // For SUB/SUBU
    wire cin = aluc[0]; // 1 for SUB/SUBU, 0 for ADD/ADDU
    
    // Carry-select adder implementation (4-bit blocks)
    wire [31:0] sum;
    wire cout;
    carry_select_adder csa(
        .a(a),
        .b(b_operand),
        .cin(cin),
        .sum(sum),
        .cout(cout)
    );

    // Shared comparator
    wire lt_signed = signed_a < signed_b;
    wire lt_unsigned = a < b;

    always @(*) begin
        // Default values
        carry = 0;
        overflow = 0;
        flag = 0;
        r = 32'b0;

        case (aluc)
            ADD, ADDU, SUB, SUBU: begin
                r = sum;
                carry = cout;
                if (aluc[1]) begin // Only for ADD/SUB
                    overflow = (a[31] == b_operand[31]) && (r[31] != a[31]);
                end
            end
            AND:  r = a & b;
            OR:   r = a | b;
            XOR:  r = a ^ b;
            NOR:  r = ~(a | b);
            SLT:  begin
                r = {31'b0, lt_signed};
                flag = lt_signed;
            end
            SLTU: begin
                r = {31'b0, lt_unsigned};
                flag = lt_unsigned;
            end
            SLL, SLLV:  r = b << shift_amount;
            SRL, SRLV:  r = b >> shift_amount;
            SRA, SRAV:  r = $signed(b) >>> shift_amount;
            LUI:  r = {b[15:0], 16'b0};
            default: r = 32'b0;
        endcase
    end

    // Optimized zero detection
    assign zero = ~(|r);
    assign negative = r[31];

endmodule

// Carry-select adder module (4-bit blocks)
module carry_select_adder(
    input [31:0] a,
    input [31:0] b,
    input cin,
    output [31:0] sum,
    output cout
);
    wire [7:0] carry;
    
    // First 4-bit ripple carry adder
    ripple_carry_adder rca0(
        .a(a[3:0]),
        .b(b[3:0]),
        .cin(cin),
        .sum(sum[3:0]),
        .cout(carry[0])
    );
    
    // 7 x 4-bit carry-select adders
    genvar i;
    generate
        for (i = 1; i < 8; i = i + 1) begin : csa_block
            wire [3:0] sum0, sum1;
            wire cout0, cout1;
            
            // Adder with carry-in 0
            ripple_carry_adder rca0(
                .a(a[(i*4)+3:i*4]),
                .b(b[(i*4)+3:i*4]),
                .cin(1'b0),
                .sum(sum0),
                .cout(cout0)
            );
            
            // Adder with carry-in 1
            ripple_carry_adder rca1(
                .a(a[(i*4)+3:i*4]),
                .b(b[(i*4)+3:i*4]),
                .cin(1'b1),
                .sum(sum1),
                .cout(cout1)
            );
            
            // Mux results based on previous carry
            assign sum[(i*4)+3:i*4] = carry[i-1] ? sum1 : sum0;
            assign carry[i] = carry[i-1] ? cout1 : cout0;
        end
    endgenerate
    
    assign cout = carry[7];
endmodule

// Basic ripple carry adder (4-bit)
module ripple_carry_adder(
    input [3:0] a,
    input [3:0] b,
    input cin,
    output [3:0] sum,
    output cout
);
    wire [4:0] c;
    assign c[0] = cin;
    
    genvar i;
    generate
        for (i = 0; i < 4; i = i + 1) begin : rca
            full_adder fa(
                .a(a[i]),
                .b(b[i]),
                .cin(c[i]),
                .sum(sum[i]),
                .cout(c[i+1])
            );
        end
    endgenerate
    
    assign cout = c[4];
endmodule

// Full adder
module full_adder(
    input a,
    input b,
    input cin,
    output sum,
    output cout
);
    assign sum = a ^ b ^ cin;
    assign cout = (a & b) | (cin & (a ^ b));
endmodule