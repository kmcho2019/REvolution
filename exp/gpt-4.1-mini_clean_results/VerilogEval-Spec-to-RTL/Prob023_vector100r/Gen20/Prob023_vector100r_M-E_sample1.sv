module BitRevN #(parameter N = 1) (
    input  wire [N-1:0] in,
    output wire [N-1:0] out
);
    // Base case: single bit reversal (no change)
    generate
        if (N == 1) begin
            assign out = in;
        end else begin
            // Split input in two halves: left (high) and right (low)
            localparam N_left  = N/2;
            localparam N_right = N - N_left;

            wire [N_left-1:0]  left_in;
            wire [N_right-1:0] right_in;

            wire [N_left-1:0]  left_out;
            wire [N_right-1:0] right_out;

            assign left_in  = in[N-1:N_right];
            assign right_in = in[N_right-1:0];

            // Recursively instantiate for left and right halves
            BitRevN #(N_right) rev_right (
                .in(right_in),
                .out(right_out)
            );

            BitRevN #(N_left) rev_left (
                .in(left_in),
                .out(left_out)
            );

            // Concatenate reversed right half first, then reversed left half
            assign out = {right_out, left_out};
        end
    endgenerate
endmodule

module TopModule (
    input  wire [99:0] in,
    output wire [99:0] out
);
    // Instantiate the recursive parameterized bit reversal module for 100 bits
    BitRevN #(100) bitrev_inst (
        .in(in),
        .out(out)
    );
endmodule