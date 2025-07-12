module DFF_sync_reset_negclk_individual (
    input          clk,
    input          reset,
    input  [7:0]   d,
    output reg [7:0] q
);
    // Negative edge triggered DFFs with synchronous active-high reset to 8'h34.
    // Each bit handled individually in generate loop.
    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : bit_ff
            always @(negedge clk) begin
                if (reset)
                    q[i] <= 1'b0; // Will override all bits with 0x34 below
                else
                    q[i] <= d[i];
            end
        end
    endgenerate

    // Override synchronous reset with constant 0x34 at once, avoiding partial resets.
    // Since each bit resets individually, assign 0x34 bits on reset:
    always @(negedge clk) begin
        if (reset)
            q <= 8'h34;
    end
endmodule

module TopModule (
    input        clk,
    input        reset,
    input  [7:0] d,
    output [7:0] q
);
    // Instantiate bitwise 8-bit negative edge triggered synchronous reset DFF
    DFF_sync_reset_negclk_individual dff_inst (
        .clk(clk),
        .reset(reset),
        .d(d),
        .q(q)
    );
endmodule