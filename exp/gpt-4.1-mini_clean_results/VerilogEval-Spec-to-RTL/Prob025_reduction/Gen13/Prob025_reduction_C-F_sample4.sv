module HalfXor(
    input  a,
    input  b,
    output y
);
    assign y = a ^ b;
endmodule

// Parameterized module to compute XOR reduction via a balanced XOR tree
module XorTree #(
    parameter WIDTH = 8
)(
    input  [WIDTH-1:0] in,
    output             out
);
    // If WIDTH == 1, output directly
    // Else recursively XOR pairs of inputs to reduce width by half each stage
    localparam NEXT_WIDTH = (WIDTH + 1) / 2;

    wire [NEXT_WIDTH-1:0] next_level;

    genvar i;
    generate
        if (WIDTH == 1) begin : base_case
            assign out = in[0];
        end else begin : recursive_case
            for (i = 0; i < NEXT_WIDTH; i = i + 1) begin : xor_pairs
                if (2*i+1 < WIDTH) begin
                    HalfXor hx(
                        .a(in[2*i]),
                        .b(in[2*i+1]),
                        .y(next_level[i])
                    );
                end else begin
                    // If odd WIDTH, pass last element unchanged
                    assign next_level[i] = in[2*i];
                end
            end

            // Recursively instantiate XorTree for next level
            XorTree #(
                .WIDTH(NEXT_WIDTH)
            ) next_stage (
                .in(next_level),
                .out(out)
            );
        end
    endgenerate
endmodule

module TopModule (
    input  [7:0] in,
    output       parity
);
    // Instantiate parameterized XOR tree for 8-bit input
    XorTree #(
        .WIDTH(8)
    ) parity_xor_tree (
        .in(in),
        .out(parity)
    );
endmodule