module DFF_with_sync_reset (
    input clk,
    input reset,
    input d,
    output reg q
);

always @(negedge clk) begin
    if (reset)
        q <= 1'b0; // This will be overridden by top-level constant loading.
    else
        q <= d;
end

endmodule

module TopModule (
    input clk,
    input reset,
    input [7:0] d,
    output [7:0] q
);
    wire [7:0] q_internal;

    genvar i;
    generate
        for (i=0; i<8; i=i+1) begin : dff_array
            // Instantiate 8 DFFs with synchronous reset
            // But since each flip-flop cannot load 0x34 alone,
            // do a mux at input d to select between d[i] and the bit of 0x34 when reset
            wire d_mux = reset ? 8'h34[i] : d[i];
            DFF_with_sync_reset dff_inst (
                .clk(clk),
                .reset(reset),
                .d(d_mux),
                .q(q_internal[i])
            );
        end
    endgenerate

    assign q = q_internal;

endmodule