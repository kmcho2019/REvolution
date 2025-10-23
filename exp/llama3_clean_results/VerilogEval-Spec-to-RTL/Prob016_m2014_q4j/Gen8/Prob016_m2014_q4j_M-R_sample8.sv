// Refactored FullAdder module
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

// Refactored TopModule
module TopModule(
    input   [3:0] x,
    input   [3:0] y,
    output  [4:0] sum
);
    wire [2:0] carry;

    // Instantiate FullAdder modules using a loop
    genvar i;
    generate
        for (i = 0; i < 4; i++) begin
            if (i == 0) begin
                FullAdder fa(
                    x[i],
                    y[i],
                    1'b0,
                    sum[i],
                    carry[i]
                );
            end else begin
                FullAdder fa(
                    x[i],
                    y[i],
                    carry[i-1],
                    sum[i],
                    carry[i]
                );
            end
        end
        assign sum[4] = carry[2];
    endgenerate
endmodule