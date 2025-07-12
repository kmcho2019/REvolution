module FullAdder(
    input  a,
    input  b,
    input  cin,
    output sum,
    output cout
);
    wire axb = a ^ b;
    assign sum = axb ^ cin;
    assign cout = (a & b) | (axb & cin);
endmodule

module TopModule(
    input  [3:0] x,
    input  [3:0] y,
    output [4:0] sum
);
    wire [3:0] carry;

    // Instantiate full adders using a generate loop for scalability and conciseness
    genvar i;
    generate
        for (i = 0; i < 4; i = i + 1) begin : adder_chain
            if (i == 0) begin
                FullAdder fa (
                    .a(x[i]),
                    .b(y[i]),
                    .cin(1'b0),
                    .sum(sum[i]),
                    .cout(carry[i])
                );
            end else begin
                FullAdder fa (
                    .a(x[i]),
                    .b(y[i]),
                    .cin(carry[i-1]),
                    .sum(sum[i]),
                    .cout(carry[i])
                );
            end
        end
    endgenerate

    // Assign the final carry-out as the overflow bit
    assign sum[4] = carry[3];
endmodule