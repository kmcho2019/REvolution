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

module TopModule(
    input   [3:0] x,
    input   [3:0] y,
    output  [4:0] sum
);

    wire [2:0] c;

    assign c[0] = (x[0] & y[0]) | (x[0] & 1'b0) | (y[0] & 1'b0);
    assign sum[0] = x[0] ^ y[0] ^ 1'b0;

    generate
        for (genvar i = 1; i < 4; i++) begin
            assign c[i-1] = (x[i] & y[i]) | (x[i] & c[i-1]) | (y[i] & c[i-1]);
            assign sum[i] = x[i] ^ y[i] ^ c[i-1];
        end
    endgenerate

    assign sum[4] = (x[3] & y[3]) | (x[3] & c[2]) | (y[3] & c[2]);

endmodule