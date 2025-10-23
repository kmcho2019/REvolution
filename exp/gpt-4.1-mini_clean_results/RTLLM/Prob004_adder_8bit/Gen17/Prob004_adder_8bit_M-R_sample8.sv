module adder_8bit (
    input  wire [7:0] a,     // 8-bit operand A
    input  wire [7:0] b,     // 8-bit operand B
    input  wire       cin,   // carry-in input
    output wire [7:0] sum,   // 8-bit sum output
    output wire       cout   // carry-out output
);
    // Function to perform 1-bit full addition returning {cout, sum}
    function [1:0] full_adder;
        input a_bit;
        input b_bit;
        input c_in;
        reg s, c_out;
        begin
            s = a_bit ^ b_bit ^ c_in;
            c_out = (a_bit & b_bit) | (b_bit & c_in) | (c_in & a_bit);
            full_adder = {c_out, s};
        end
    endfunction

    // Internal carry signals
    wire [7:0] carry;
    
    // Intermediate wires for sum bits
    reg [7:0] sum_reg;
    reg carry_in;
    integer i;

    // Combinational logic for ripple carry addition
    always @(*) begin
        carry_in = cin;
        for (i = 0; i < 8; i = i + 1) begin
            {carry[i], sum_reg[i]} = full_adder(a[i], b[i], carry_in);
            carry_in = carry[i];
        end
    end

    // Output assignments
    assign sum = sum_reg;
    assign cout = carry[7];
endmodule