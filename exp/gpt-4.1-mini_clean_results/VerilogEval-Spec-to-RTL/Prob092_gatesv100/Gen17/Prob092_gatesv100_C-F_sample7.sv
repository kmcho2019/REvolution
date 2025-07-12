module TopModule(
    input  wire [99:0] in,
    output reg  [99:0] out_both,
    output reg  [99:0] out_any,
    output reg  [99:0] out_different
);

    // Prepare wrapped left neighbors for out_different:
    // left_neighbor[i] = in[(i+1) mod 100], i.e., neighbor to the left with wrap-around
    wire [99:0] left_neighbor_for_diff = {in[0], in[99:1]};

    integer i;

    always @(*) begin
        for (i = 0; i < 100; i = i + 1) begin
            // out_both[i]: Check if in[i] and its left neighbor in[i+1] are both '1'
            // For i=0..98: use in[i] & in[i+1]
            // For i=99 (no left neighbor): set to 0
            if (i < 99)
                out_both[i] = in[i] & in[i+1];
            else
                out_both[i] = 1'b0;

            // out_any[i]: Check if in[i] or its right neighbor in[i-1] is '1'
            // For i=1..99: use in[i] | in[i-1]
            // For i=0 (no right neighbor): set to 0
            if (i > 0)
                out_any[i] = in[i] | in[i-1];
            else
                out_any[i] = 1'b0;

            // out_different[i]: in[i] xor its left neighbor with wrap-around,
            // using precomputed left_neighbor_for_diff vector for clarity and efficiency
            out_different[i] = in[i] ^ left_neighbor_for_diff[i];
        end
    end

endmodule