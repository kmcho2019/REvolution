// FullAdder module remains the same
module FullAdder(
    input   a,
    input   b,
    input   cin,
    output  sum,
    output  cout
);
    assign sum = a ^ b ^ cin;
    assign cout = (a & b) | (a & cin) | (b & cin);
endmodule

// Refactored TopModule using generate block
module TopModule(
    input   [3:0] x,
    input   [3:0] y,
    output  [4:0] sum
);
    wire [2:0] carry;

    // Instantiate full adders in a loop
    generate
        for (genvar i = 0; i < 4; i++) begin
            if (i == 0) begin
                FullAdder fa(.a(x[i]), .b(y[i]), .cin(1'b0), .sum(sum[i]), .cout(carry[i]));
            end else begin
                FullAdder fa(.a(x[i]), .b(y[i]), .cin(carry[i-1]), .sum(sum[i]), .cout(carry[i]));
            end
        end
    endgenerate

    // The most significant bit of sum is the carry out of the last full adder
    assign sum[4] = carry[2];
endmodule