module DFF_sync_reset_negclk_bit #(
    parameter RESET_VAL = 1'b0
) (
    input        clk,
    input        reset,
    input        d,
    output reg   q
);
    // Negative edge triggered DFF with synchronous active-high reset
    always @(negedge clk) begin
        if (reset)
            q <= RESET_VAL;
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
    // Reset value 0x34: 8'b0011_0100
    localparam [7:0] RESET_VAL = 8'h34;

    // Implement vector of DFF bits using generate and parametrized single-bit DFF modules,
    // this maintains modularity but consolidates area by vector wiring.
    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : dff_bits
            DFF_sync_reset_negclk_bit #(.RESET_VAL(RESET_VAL[i])) dff_inst (
                .clk(clk),
                .reset(reset),
                .d(d[i]),
                .q(q[i])
            );
        end
    endgenerate
endmodule