module DFF_NegEdge_SyncReset #(
    parameter RESET_VAL = 1'b0
) (
    input clk,
    input reset,
    input d,
    output reg q
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
    // Constant reset value 0x34 split into bits
    localparam [7:0] RESET_VAL = 8'h34;

    // Instantiate 8 DFFs, one per bit
    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : DFF_ARRAY
            DFF_NegEdge_SyncReset #(.RESET_VAL(RESET_VAL[i])) dff (
                .clk(clk),
                .reset(reset),
                .d(d[i]),
                .q(q[i])
            );
        end
    endgenerate

endmodule