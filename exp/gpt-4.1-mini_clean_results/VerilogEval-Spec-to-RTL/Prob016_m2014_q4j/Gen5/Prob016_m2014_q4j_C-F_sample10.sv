module FullAdder (
    input  wire a,
    input  wire b,
    input  wire cin,
    output wire sum,
    output wire cout
);
    assign sum  = a ^ b ^ cin;
    assign cout = (a & b) | (b & cin) | (a & cin);
endmodule

module TopModule (
    input  wire [3:0] x,
    input  wire [3:0] y,
    output wire [4:0] sum
);
    wire [3:0] carry; // Internal carry signals between full adders

    genvar i;
    generate
        for (i = 0; i < 4; i = i + 1) begin : full_adder_loop
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

    assign sum[4] = carry[3]; // final carry-out as the overflow bit
endmodule