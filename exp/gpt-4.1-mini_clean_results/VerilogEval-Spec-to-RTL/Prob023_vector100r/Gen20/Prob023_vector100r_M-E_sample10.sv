module BitReverseN #(parameter N = 1) (
    input  wire [N-1:0] in,
    output wire [N-1:0] out
);
    // Base case: if width is 1, just output the input
    generate
        if (N == 1) begin
            assign out = in;
        end else begin
            // Split input into two halves
            localparam HALF = N / 2;
            wire [HALF-1:0] left_in  = in[N-1 -: HALF];
            wire [HALF-1:0] right_in = in[HALF-1:0];
            wire [HALF-1:0] left_out, right_out;

            // Recursively reverse each half
            BitReverseN #(HALF) left_rev  (.in(left_in),  .out(left_out));
            BitReverseN #(HALF) right_rev (.in(right_in), .out(right_out));

            // Concatenate reversed halves swapped to complete reversal
            assign out = {right_out, left_out};
        end
    endgenerate
endmodule

module TopModule (
    input  wire [99:0] in,
    output wire [99:0] out
);
    // Use BitReverseN with N=100 for full reversal
    BitReverseN #(100) full_reverse (
        .in(in),
        .out(out)
    );
endmodule