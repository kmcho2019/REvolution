module DFFNegEdgeSyncReset (
    input       clk,
    input       reset,
    input       d,
    output reg  q
);
    // Negative edge triggered DFF with synchronous active-high reset loading 1-bit reset value
    always @(negedge clk) begin
        if (reset)
            q <= 1'b0;  // Will be overridden by TopModule parameter for reset bit
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
    // Constant reset pattern 0x34 = 8'b0011_0100
    localparam [7:0] RESET_VAL = 8'h34;

    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : dff_bits
            // Instantiate each DFF with synchronous reset loading RESET_VAL bit
            // We use a wire to connect the reset bit for each flip-flop
            wire reset_bit = reset ? RESET_VAL[i] : 1'bx; // 'x' for no effect since reset is synchronous in DFF

            // Instantiate flip-flop, overriding synchronous reset inside by condition
            // We cannot directly assign a reset value bit to DFF, so we modify the module to accept a reset value bit input
            // For this, we modify the DFF module to take reset_bit input and load it during reset

            DFFNegEdgeSyncResetBit dff_inst (
                .clk(clk),
                .reset(reset),
                .reset_val(RESET_VAL[i]),
                .d(d[i]),
                .q(q[i])
            );
        end
    endgenerate
endmodule

module DFFNegEdgeSyncResetBit (
    input       clk,
    input       reset,
    input       reset_val,
    input       d,
    output reg  q
);
    // Negative edge triggered DFF with synchronous active-high reset loading reset_val bit
    always @(negedge clk) begin
        if (reset)
            q <= reset_val;
        else
            q <= d;
    end
endmodule