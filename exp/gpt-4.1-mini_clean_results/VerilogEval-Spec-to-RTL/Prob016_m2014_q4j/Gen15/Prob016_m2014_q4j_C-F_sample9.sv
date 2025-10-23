module FullAdder (
    input  a,
    input  b,
    input  cin,
    output sum,
    output cout
);
    assign sum  = a ^ b ^ cin;
    assign cout = (a & b) | (b & cin) | (a & cin);
endmodule

module TopModule (
    input  [3:0] x,
    input  [3:0] y,
    output [4:0] sum
);
    wire [3:0] carry;

    // Instantiate the least significant full adder with cin = 0
    FullAdder fa0 (
        .a(x[0]),
        .b(y[0]),
        .cin(1'b0),
        .sum(sum[0]),
        .cout(carry[0])
    );

    // Generate the remaining full adders (bits 1 to 3) using a for-generate loop
    genvar i;
    generate
        for (i = 1; i < 4; i = i + 1) begin : adders
            FullAdder fa (
                .a(x[i]),
                .b(y[i]),
                .cin(carry[i-1]),
                .sum(sum[i]),
                .cout(carry[i])
            );
        end
    endgenerate

    // Assign the overflow bit as the final carry out
    assign sum[4] = carry[3];

endmodule