module DFF_SyncReset_NegEdge (
    input clk,
    input reset,
    input d,
    output reg q,
    input load_enable,
    input reset_val
);
    // Negative edge triggered DFF with synchronous active-high reset and load enable
    always @(negedge clk) begin
        if (reset)
            q <= reset_val;
        else if (load_enable)
            q <= d;
        else
            q <= q; // Hold state if not loading
    end
endmodule

module TopModule (
    input        clk,
    input        reset,
    input  [7:0] d,
    output [7:0] q
);

    // Constant reset value
    localparam [7:0] RESET_VAL = 8'h34;

    // Generate load enable: only load new d when reset or input changes to reduce toggling
    wire [7:0] load_enable_bits;
    genvar i;

    generate
        for (i = 0; i < 8; i = i + 1) begin : dffs
            // Generate load enable: load when reset or input d bit differs from q bit
            // We'll do combinational comparison of d and q to generate load_enable
            // But q is registered output; to avoid combinational loop, assume load_enable always asserted
            // because load_enable uses q and q updates on negedge clk, not safe to use in combinational
            // So here we implement simple load_enable as always 1 for simplicity.
            // Advanced clock gating or enable logic should be done in synthesis or RTL top layer.

            // For correctness and simplicity, tie load_enable=1
            DFF_SyncReset_NegEdge dff_inst (
                .clk(clk),
                .reset(reset),
                .d(d[i]),
                .q(q[i]),
                .load_enable(1'b1),
                .reset_val(RESET_VAL[i])
            );
        end
    endgenerate

endmodule