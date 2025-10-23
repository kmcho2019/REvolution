// D flip-flop with internal clock enable to reduce switching activity
// Updates q only when d differs from q, gating unnecessary toggles
module DFF (
    input  wire clk,
    input  wire d,
    output reg  q
);
    // synthesis attribute equivalent_register "yes" of q is "true"; // Adjust per vendor if needed

    always @(posedge clk) begin
        if (d != q)
            q <= d;
    end
endmodule

// Top-level module instantiates the gated DFF
module TopModule (
    input  wire clk,
    input  wire d,
    output wire q
);
    DFF dff_inst (
        .clk(clk),
        .d(d),
        .q(q)
    );
endmodule