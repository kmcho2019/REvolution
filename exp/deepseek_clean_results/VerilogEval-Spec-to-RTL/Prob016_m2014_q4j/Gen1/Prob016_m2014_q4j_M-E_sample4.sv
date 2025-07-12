module TopModule(
    input [3:0] x,
    input [3:0] y,
    output [4:0] sum
);

    wire [1:0] sum_low;          // Lower 2-bit sum
    wire [2:0] sum_high_0;       // Upper bits assuming carry-in=0
    wire [2:0] sum_high_1;       // Upper bits assuming carry-in=1
    wire carry_low;              // Carry out from lower bits
    wire [2:0] sum_high_selected;// Selected upper bits based on carry_low

    // Lower 2-bit ripple carry adder
    wire c0;
    full_adder fa0(.a(x[0]), .b(y[0]), .cin(1'b0), .sum(sum_low[0]), .cout(c0));
    full_adder fa1(.a(x[1]), .b(y[1]), .cin(c0), .sum(sum_low[1]), .cout(carry_low));

    // Upper 2-bit adders (both carry-in cases)
    // Case when carry-in = 0
    wire c1_0;
    full_adder fa2_0(.a(x[2]), .b(y[2]), .cin(1'b0), .sum(sum_high_0[0]), .cout(c1_0));
    full_adder fa3_0(.a(x[3]), .b(y[3]), .cin(c1_0), .sum(sum_high_0[1]), .cout(sum_high_0[2]));

    // Case when carry-in = 1
    wire c1_1;
    full_adder fa2_1(.a(x[2]), .b(y[2]), .cin(1'b1), .sum(sum_high_1[0]), .cout(c1_1));
    full_adder fa3_1(.a(x[3]), .b(y[3]), .cin(c1_1), .sum(sum_high_1[1]), .cout(sum_high_1[2]));

    // Select the correct upper sum based on lower carry
    assign sum_high_selected = carry_low ? sum_high_1 : sum_high_0;

    // Combine the results
    assign sum = {sum_high_selected, sum_low};

endmodule

// Full adder module definition
module full_adder(
    input a,
    input b,
    input cin,
    output sum,
    output cout
);
    assign sum = a ^ b ^ cin;
    assign cout = (a & b) | (b & cin) | (a & cin);
endmodule