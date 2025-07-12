module BitRevN #(parameter N = 1) (
    input  wire [N-1:0] in,
    output wire [N-1:0] out
);
    // Base case: single bit, just connect input to output
    generate
        if (N == 1) begin
            assign out = in;
        end else begin
            // Split input into two halves
            localparam HALF = N / 2;
            localparam REM = N - HALF;

            wire [HALF-1:0] lower_in = in[HALF-1:0];
            wire [HALF-1:0] upper_in = in[N-1:HALF];
            wire [HALF-1:0] lower_out;
            wire [HALF-1:0] upper_out;

            BitRevN #(HALF) lower_rev (
                .in(lower_in),
                .out(lower_out)
            );

            BitRevN #(HALF) upper_rev (
                .in(upper_in),
                .out(upper_out)
            );

            // Handle any leftover bits (if N is odd)
            wire [REM-1:0] rem_in = in[REM-1:0];
            wire [REM-1:0] rem_out;

            if (N % 2 != 0) begin : odd_bits
                BitRevN #(REM) rem_rev (
                    .in(rem_in),
                    .out(rem_out)
                );
            end else begin : even_bits
                // No leftover bits if even
                assign rem_out = 'b0;
            end

            // Compose output: reversed upper half + reversed lower half (and leftover bits)
            // Because of integer division, adjust concatenation accordingly:
            if (N % 2 == 0) begin
                assign out = {lower_out, upper_out};
            end else begin
                // When odd, N = 2*HALF + 1
                assign out = {rem_out, lower_out, upper_out};
            end
        end
    endgenerate
endmodule

module TopModule (
    input  wire [99:0] in,
    output wire [99:0] out
);
    // Because 100 is even, N=100, HALFS=50
    // But the above code doesn't handle odd splitting fully, let's simplify

    // For simplicity, we implement a variant: recursively divide until size=1

    // So, let's re-implement BitRevN with clean recursive splitting handling powers of two only
endmodule

// To fix the above complexity, let's define a clean recursive BitRevN handling any N by splitting into two parts:

module BitRevN #(parameter N = 1) (
    input  wire [N-1:0] in,
    output wire [N-1:0] out
);
    generate
        if (N == 1) begin
            assign out = in;
        end else begin
            localparam HALF = N / 2;
            localparam REM = N - HALF; // REM = HALF if even; else REM > HALF by 1
            wire [HALF-1:0] lower_in = in[HALF-1:0];
            wire [REM-1:0] upper_in = in[N-1:HALF];
            wire [HALF-1:0] lower_out;
            wire [REM-1:0] upper_out;

            BitRevN #(HALF) lower_rev (
                .in(lower_in),
                .out(lower_out)
            );

            BitRevN #(REM) upper_rev (
                .in(upper_in),
                .out(upper_out)
            );

            assign out = {lower_out, upper_out};
        end
    endgenerate
endmodule

module TopModule (
    input  wire [99:0] in,
    output wire [99:0] out
);
    BitRevN #(100) bitrev (
        .in(in),
        .out(out)
    );
endmodule