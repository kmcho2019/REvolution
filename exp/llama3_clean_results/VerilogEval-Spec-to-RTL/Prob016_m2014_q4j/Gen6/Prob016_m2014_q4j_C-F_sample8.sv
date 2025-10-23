// Define a full adder module with explicit naming convention
module FullAdderModule(
    input   a_bit,
    input   b_bit,
    input   carry_in,
    output  sum_bit,
    output  carry_out
);
    // The sum is calculated using the XOR operation
    assign sum_bit = a_bit ^ b_bit ^ carry_in;
    // The carry-out is calculated using the AND operation
    assign carry_out = (a_bit & b_bit) | (a_bit & carry_in) | (b_bit & carry_in);
endmodule

// TopModule that instantiates full adders with clear naming convention
module TopModule(
    input   [3:0] x_input,
    input   [3:0] y_input,
    output  [4:0] sum_output
);
    // Internal wires for carry signals with clear naming
    wire carry_1, carry_2, carry_3;

    // Instantiate FullAdder modules for each bit position with clear naming
    FullAdderModule fa_0(
      .a_bit(x_input[0]),
      .b_bit(y_input[0]),
      .carry_in(1'b0),
      .sum_bit(sum_output[0]),
      .carry_out(carry_1)
    );

    FullAdderModule fa_1(
      .a_bit(x_input[1]),
      .b_bit(y_input[1]),
      .carry_in(carry_1),
      .sum_bit(sum_output[1]),
      .carry_out(carry_2)
    );

    FullAdderModule fa_2(
      .a_bit(x_input[2]),
      .b_bit(y_input[2]),
      .carry_in(carry_2),
      .sum_bit(sum_output[2]),
      .carry_out(carry_3)
    );

    FullAdderModule fa_3(
      .a_bit(x_input[3]),
      .b_bit(y_input[3]),
      .carry_in(carry_3),
      .sum_bit(sum_output[3]),
      .carry_out(sum_output[4])
    );
endmodule