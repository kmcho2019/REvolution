module adder_8bit (
    input  wire [7:0] a,
    input  wire [7:0] b,
    input  wire       cin,
    output wire [7:0] sum,
    output wire       cout
);

    // Function to perform single bit full addition
    function [1:0] full_adder_bit;
        input a_bit;
        input b_bit;
        input c_in;
        begin
            full_adder_bit[0] = a_bit ^ b_bit ^ c_in;                                  // sum bit
            full_adder_bit[1] = (a_bit & b_bit) | (b_bit & c_in) | (a_bit & c_in);   // carry out
        end
    endfunction

    wire [7:0] carry;
    wire [1:0] fa_out;

    // Bit 0
    assign fa_out = full_adder_bit(a[0], b[0], cin);
    assign sum[0]  = fa_out[0];
    assign carry[0] = fa_out[1];

    // Bit 1
    assign fa_out = full_adder_bit(a[1], b[1], carry[0]);
    assign sum[1]  = fa_out[0];
    assign carry[1] = fa_out[1];

    // Bit 2
    assign fa_out = full_adder_bit(a[2], b[2], carry[1]);
    assign sum[2]  = fa_out[0];
    assign carry[2] = fa_out[1];

    // Bit 3
    assign fa_out = full_adder_bit(a[3], b[3], carry[2]);
    assign sum[3]  = fa_out[0];
    assign carry[3] = fa_out[1];

    // Bit 4
    assign fa_out = full_adder_bit(a[4], b[4], carry[3]);
    assign sum[4]  = fa_out[0];
    assign carry[4] = fa_out[1];

    // Bit 5
    assign fa_out = full_adder_bit(a[5], b[5], carry[4]);
    assign sum[5]  = fa_out[0];
    assign carry[5] = fa_out[1];

    // Bit 6
    assign fa_out = full_adder_bit(a[6], b[6], carry[5]);
    assign sum[6]  = fa_out[0];
    assign carry[6] = fa_out[1];

    // Bit 7
    assign fa_out = full_adder_bit(a[7], b[7], carry[6]);
    assign sum[7]  = fa_out[0];
    assign cout    = fa_out[1];

endmodule