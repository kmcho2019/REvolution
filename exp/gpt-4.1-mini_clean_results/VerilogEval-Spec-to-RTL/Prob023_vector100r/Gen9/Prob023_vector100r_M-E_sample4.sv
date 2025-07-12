module BitReverseTree #(parameter N = 100) (
    input  [N-1:0] in,
    output [N-1:0] out
);
    // Since N=100 < 128, use 7 stages (2^7=128)
    localparam STAGES = 7;
    // Extend input to 128 bits for simplicity
    wire [127:0] stage [0:STAGES];
    assign stage[0] = { {(128 - N){1'b0}}, in }; // zero-extend MSBs

    genvar s, i;
    generate
        for (s = 0; s < STAGES; s = s + 1) begin : stages
            wire [127:0] prev = stage[s];
            wire [127:0] curr;
            localparam int swap_dist = 1 << s;
            for (i = 0; i < 128; i = i + 1) begin : bits
                // Calculate the pair index and parity to decide swapping
                // We swap bits i and i ^ swap_dist for i < i ^ swap_dist
                // To avoid double swapping, define that if (i & swap_dist)==0,
                // swap with bit at i+swap_dist
                if ((i & swap_dist) == 0 && (i + swap_dist) < 128) begin : swap_pair
                    assign curr[i]           = prev[i + swap_dist];
                    assign curr[i + swap_dist] = prev[i];
                end else if ((i & swap_dist) != 0) begin : no_assign /* handled by swap_pair */ end
                else begin : no_swap
                    // If no pair, just forward
                    assign curr[i] = prev[i];
                end
            end
            assign stage[s+1] = curr;
        end
    endgenerate

    // Output is lower N bits of final stage output
    assign out = stage[STAGES][N-1:0];
endmodule

module TopModule (
    input  [99:0] in,
    output [99:0] out
);
    BitReverseTree #(100) bitrev_inst (
        .in(in),
        .out(out)
    );
endmodule