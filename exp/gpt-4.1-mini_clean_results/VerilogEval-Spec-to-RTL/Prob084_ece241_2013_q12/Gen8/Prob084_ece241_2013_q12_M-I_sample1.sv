module TopModule (
    input  clk,
    input  enable,
    input  S,
    input  A,
    input  B,
    input  C,
    output Z
);

    reg [7:0] Q;

    // Gated clock generation (simple AND latch gating)
    // Latch to hold enable stable during clk high phase to avoid glitches
    reg enable_latch;
    always @(posedge clk or negedge clk) begin
        if (~clk)
            enable_latch <= enable;
    end
    wire gated_clk = clk & enable_latch;

    // Shift register: shift left with S into Q[0] on posedge gated_clk
    always @(posedge gated_clk) begin
        Q <= {Q[6:0], S};
    end

    // Direct vector indexing for output Z based on ABC as index to Q
    assign Z = Q[{A,B,C}];

endmodule