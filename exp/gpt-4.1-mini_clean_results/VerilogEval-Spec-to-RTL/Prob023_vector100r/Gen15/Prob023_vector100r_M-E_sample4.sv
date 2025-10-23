module BitRevN #(parameter N = 1) (
    input  wire [N-1:0] in,
    output wire [N-1:0] out
);
    // Base case: N == 1, output equals input directly
    generate
        if (N == 1) begin
            assign out = in;
        end else begin
            // Compute split points
            localparam int half1 = N/2;
            localparam int half2 = N - half1;

            // Split input into two parts
            wire [half1-1:0] in_hi = in[N-1 -: half1];      // upper half bits
            wire [half2-1:0] in_lo = in[half2-1:0];         // lower half bits

            // Wires for reversed halves
            wire [half1-1:0] rev_hi;
            wire [half2-1:0] rev_lo;

            // Recursive instantiations
            BitRevN #(half1) rev_hi_inst (.in(in_hi), .out(rev_hi));
            BitRevN #(half2) rev_lo_inst (.in(in_lo), .out(rev_lo));

            // Concatenate reversed halves swapped to produce full reversal
            assign out = {rev_lo, rev_hi};
        end
    endgenerate
endmodule


module TopModule (
    input  wire [99:0] in,
    output wire [99:0] out
);

    BitRevN #(100) bitrev_inst (
        .in(in),
        .out(out)
    );

endmodule