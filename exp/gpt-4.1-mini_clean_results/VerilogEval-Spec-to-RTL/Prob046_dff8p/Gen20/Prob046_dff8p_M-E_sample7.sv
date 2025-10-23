module NegEdgeDFF (
    input  clk,
    input  reset,
    input  d,
    output reg q
);
    // Synchronous active-high reset, negative-edge clock triggered
    always @(negedge clk) begin
        if (reset)
            q <= 1'b0; // default bit reset value will be set by TopModule logic
        else
            q <= d;
    end
endmodule

module TopModule (
    input          clk,
    input          reset,
    input  [7:0]   d,
    output [7:0]   q
);

    // Constant reset value 0x34 = 8'b00110100
    wire [7:0] reset_val = 8'h34;

    // Internal wires for each flip-flop output
    wire [7:0] q_internal;

    // Instantiate 8 single-bit DFFs with synchronous reset
    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : dff_bits
            // Modify reset behavior for each bit: output reset_val[i] on reset
            // Achieved by muxing d input: if reset is asserted, feed reset_val[i]
            // Otherwise feed d[i]. DFF itself resets to 0 synchronously.
            wire dff_d = reset ? reset_val[i] : d[i];
            NegEdgeDFF dff_inst (
                .clk(clk),
                .reset(reset),  // synchronous reset (sets q to 0)
                .d(dff_d),
                .q(q_internal[i])
            );
        end
    endgenerate

    assign q = q_internal;

endmodule