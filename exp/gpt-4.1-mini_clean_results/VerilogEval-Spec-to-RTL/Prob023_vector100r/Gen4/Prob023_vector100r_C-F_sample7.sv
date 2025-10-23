module BitRevN #(parameter N = 100) (
    input  [N-1:0] in,
    output [N-1:0] out
);
    genvar i;
    generate
        for (i = 0; i < N; i = i + 1) begin : bit_reverse
            assign out[i] = in[N - 1 - i];
        end
    endgenerate
endmodule

module TopModule (
    input  [99:0] in,
    output [99:0] out
);

    // Instantiate BitRevN to reverse all 100 bits directly without intermediate hierarchy
    BitRevN #(100) bitrev100 (
        .in(in),
        .out(out)
    );

endmodule