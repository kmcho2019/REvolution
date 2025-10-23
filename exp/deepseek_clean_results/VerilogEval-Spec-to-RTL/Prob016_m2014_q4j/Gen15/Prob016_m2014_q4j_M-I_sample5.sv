module FullAdder(
    input a,
    input b,
    input cin,
    output sum,
    output cout
);
    assign sum = a ^ b ^ cin;
    assign cout = (a & b) | (a & cin) | (b & cin);
endmodule

module TopModule(
    input [3:0] x,
    input [3:0] y,
    output [4:0] sum
);
    wire [3:1] carry;  // Only need carry[1:3]
    
    // LSB with no carry-in
    FullAdder fa0(
        .a(x[0]),
        .b(y[0]),
        .cin(1'b0),
        .sum(sum[0]),
        .cout(carry[1])
    );
    
    // Middle bits using generate
    genvar i;
    generate
        for (i = 1; i < 3; i = i + 1) begin : adder_chain
            FullAdder fa(
                .a(x[i]),
                .b(y[i]),
                .cin(carry[i]),
                .sum(sum[i]),
                .cout(carry[i+1])
            );
        end
    endgenerate
    
    // MSB with carry-out to sum[4]
    FullAdder fa3(
        .a(x[3]),
        .b(y[3]),
        .cin(carry[3]),
        .sum(sum[3]),
        .cout(sum[4])
    );
endmodule