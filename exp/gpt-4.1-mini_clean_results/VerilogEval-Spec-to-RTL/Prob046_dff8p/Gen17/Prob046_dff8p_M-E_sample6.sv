module DFF_negclk_sync_reset (
    input clk,
    input reset,
    input d,
    output reg q
);
    // Negative-edge triggered DFF with synchronous active-high reset
    // Reset value to be provided by parent module
    always @(negedge clk) begin
        if (reset)
            q <= 1'b0;  // reset to 0 here, parent overrides by assigning init value
        else
            q <= d;
    end
endmodule

module TopModule (
    input        clk,
    input        reset,
    input  [7:0] d,
    output [7:0] q
);
    // reset_value hardcoded to 0x34 = 8'b00110100
    wire [7:0] reset_value = 8'h34;

    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : gen_dffs
            // We instantiate individual DFFs.
            // Use an internal signal to feed either reset_value bit or d bit depending on reset.
            wire dff_d;
            // Use mux to choose reset bit or d input synchronously since DFF resets to 0 internally.
            // We compensate by forcing d input to reset_value[i] during reset, so output sets correctly.
            assign dff_d = reset ? reset_value[i] : d[i];

            DFF_negclk_sync_reset dff_inst (
                .clk(clk),
                .reset(reset),
                .d(dff_d),
                .q(q[i])
            );
        end
    endgenerate

endmodule