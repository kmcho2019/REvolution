module DFF_SyncReset_NegEdge (
    input clk,
    input reset,
    input d,
    output reg q,
    input reset_val
);
    always @(negedge clk) begin
        if (reset)
            q <= reset_val;
        else
            q <= d;
    end
endmodule

module TopModule(
    input clk,
    input reset,
    input [7:0] d,
    output [7:0] q
);

    // Constant reset value 0x34 = 8'b00110100
    localparam [7:0] RESET_VAL = 8'h34;

    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : DFF_ARRAY
            DFF_SyncReset_NegEdge dff_inst (
                .clk(clk),
                .reset(reset),
                .d(d[i]),
                .q(q[i]),
                .reset_val(RESET_VAL[i])
            );
        end
    endgenerate

endmodule