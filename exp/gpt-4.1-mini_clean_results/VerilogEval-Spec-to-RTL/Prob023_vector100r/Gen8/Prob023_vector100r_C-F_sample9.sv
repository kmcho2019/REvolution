// Parameterized module to reverse N-bit vector bitwise
module BitRevN #(parameter N = 100) (
    input  wire [N-1:0] in,
    output wire [N-1:0] out
);
    genvar i;
    generate
        // Assign each output bit to corresponding reversed input bit
        for (i = 0; i < N; i = i + 1) begin : bit_reverse_loop
            assign out[i] = in[N - 1 - i];
        end
    endgenerate
endmodule

// Top-level module with 100-bit input/output ports
module TopModule (
    input  wire [99:0] in,
    output wire [99:0] out
);
    // Instantiate the BitRevN module with N=100
    BitRevN #(100) bitrev_inst (
        .in(in),
        .out(out)
    );
endmodule