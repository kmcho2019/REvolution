module BitRevN #(parameter N = 100) (
    input  wire [N-1:0] in,
    output wire [N-1:0] out
);
    genvar i;
    generate
        for (i = 0; i < N; i = i + 1) begin : bit_reverse
            assign out[i] = in[N - 1 - i];
        end
    endgenerate
endmodule

module TopModule (
    input  wire [99:0] in,
    output wire [99:0] out
);
    // Instantiate BitRevN for full 100-bit reversal
    BitRevN #(100) bitrev_inst (
        .in(in),
        .out(out)
    );
endmodule