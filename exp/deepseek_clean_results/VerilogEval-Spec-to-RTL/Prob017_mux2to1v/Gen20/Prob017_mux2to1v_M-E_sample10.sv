module TopModule (
    input  [99:0] a,
    input  [99:0] b,
    input         sel,
    output [99:0] out
);

    // Encode selection into control signals
    wire a_enable = ~sel;
    wire b_enable = sel;

    // Gate the inputs with enable signals
    wire [99:0] a_gated = a & {100{a_enable}};
    wire [99:0] b_gated = b & {100{b_enable}};

    // Combine the gated inputs
    assign out = a_gated | b_gated;

endmodule