// Parameterized module to reverse bits of an N-bit input vector
module BitRevN #(parameter N = 100) (
    input  wire [N-1:0] in,
    output wire [N-1:0] out
);
    // Generate loop for bit reversal
    genvar i;
    generate
        for (i = 0; i < N; i = i + 1) begin : bit_reverse
            assign out[i] = in[N - 1 - i];
        end
    endgenerate
endmodule

// Top-level module instantiating BitRevN with N=100
module TopModule (
    input  wire [99:0] in,
    output wire [99:0] out
);
    // Instantiate bit reversal module
    BitRevN #(100) bitrev_inst (
        .in(in),
        .out(out)
    );
endmodule