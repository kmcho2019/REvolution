module DFF_NegEdge_SyncReset_Param #(
    parameter RESET_VAL = 1'b0
) (
    input clk,
    input reset,
    input d,
    output reg q
);
    // Negative edge triggered DFF with synchronous reset loading RESET_VAL
    always @(negedge clk) begin
        if (reset)
            q <= RESET_VAL;
        else
            q <= d;
    end
endmodule

module TopModule (
    input         clk,
    input         reset,
    input  [7:0]  d,
    output [7:0]  q
);
    // Define reset vector constant
    localparam [7:0] RESET_VECTOR = 8'h34;

    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : dff_array
            DFF_NegEdge_SyncReset_Param #(
                .RESET_VAL(RESET_VECTOR[i])
            ) dff_inst (
                .clk(clk),
                .reset(reset),
                .d(d[i]),
                .q(q[i])
            );
        end
    endgenerate
endmodule