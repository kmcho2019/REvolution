module adder_8bit (
    input  wire [7:0] a,      // 8-bit operand A
    input  wire [7:0] b,      // 8-bit operand B
    input  wire       cin,    // carry-in input
    output reg  [7:0] sum,    // 8-bit sum output
    output reg        cout    // carry-out output
);

    // Full adder function: returns {carry_out, sum_bit}
    function [1:0] full_adder_bit;
        input a_bit;
        input b_bit;
        input c_in;
        reg   s;
        reg   c_out;
    begin
        s = a_bit ^ b_bit ^ c_in;
        c_out = (a_bit & b_bit) | (b_bit & c_in) | (a_bit & c_in);
        full_adder_bit = {c_out, s};
    end
    endfunction

    integer i;
    reg c;  // carry variable

    always @(*) begin
        c = cin;
        for (i = 0; i < 8; i = i + 1) begin
            {c, sum[i]} = full_adder_bit(a[i], b[i], c);
        end
        cout = c;
    end

endmodule