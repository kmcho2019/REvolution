module TopModule(
    input  wire in,
    output wire out
);

    // Internal tri-state net
    wire tri_net;

    // Driver enable always on since 'in' is always driving
    // Model tri-state driver driving 'in' onto tri_net
    assign tri_net = in ? 1'bz : 1'b0; // Actually, to avoid ambiguity:
    // Better to drive tri_net directly with in, and out reads tri_net

    // Revised tri-state driver: drive tri_net with 'in' always
    assign tri_net = in;

    // Output reads from tri_net (wire with potential multiple drivers)
    assign out = tri_net;

endmodule