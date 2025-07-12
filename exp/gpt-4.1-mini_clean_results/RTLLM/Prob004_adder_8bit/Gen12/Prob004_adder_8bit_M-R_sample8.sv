module adder_8bit (
    input  wire [7:0] a,    // 8-bit operand A
    input  wire [7:0] b,    // 8-bit operand B
    input  wire       cin,  // carry-in input
    output wire [7:0] sum,  // 8-bit sum output
    output wire       cout  // carry-out output
);
    // Internal carries between bit positions
    wire [7:0] carry;

    // Full adder function: returns {carry_out, sum}
    function [1:0] full_adder;
        input a_bit;
        input b_bit;
        input c_in;
        reg sum_bit;
        reg c_out;
        begin
            sum_bit = a_bit ^ b_bit ^ c_in;
            c_out   = (a_bit & b_bit) | (a_bit & c_in) | (b_bit & c_in);
            full_adder = {c_out, sum_bit};
        end
    endfunction

    // Calculate bit 0
    assign {carry[0], sum[0]} = full_adder(a[0], b[0], cin);

    // Calculate bits 1 to 6
    assign {carry[1], sum[1]} = full_adder(a[1], b[1], carry[0]);
    assign {carry[2], sum[2]} = full_adder(a[2], b[2], carry[1]);
    assign {carry[3], sum[3]} = full_adder(a[3], b[3], carry[2]);
    assign {carry[4], sum[4]} = full_adder(a[4], b[4], carry[3]);
    assign {carry[5], sum[5]} = full_adder(a[5], b[5], carry[4]);
    assign {carry[6], sum[6]} = full_adder(a[6], b[6], carry[5]);

    // Calculate bit 7 and output carry out
    assign {cout, sum[7]} = full_adder(a[7], b[7], carry[6]);

endmodule