module TopModule (
    input clk,
    input reset,
    input [7:0] d,
    output [7:0] q
);

    // Internal signals for flip-flop implementation
    wire [7:0] master_latch;
    wire [7:0] slave_latch;
    wire [7:0] reset_mux_out;

    // Generate block for 8 D flip-flops
    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : dff_gen
            // Reset multiplexer - selects 0 when reset is high
            assign reset_mux_out[i] = reset ? 1'b0 : d[i];

            // Master latch (negative level-sensitive)
            bufif1 master_buf(master_latch[i], reset_mux_out[i], ~clk);

            // Slave latch (positive level-sensitive)
            bufif1 slave_buf(slave_latch[i], master_latch[i], clk);

            // Output buffer
            buf output_buf(q[i], slave_latch[i]);
        end
    endgenerate

endmodule