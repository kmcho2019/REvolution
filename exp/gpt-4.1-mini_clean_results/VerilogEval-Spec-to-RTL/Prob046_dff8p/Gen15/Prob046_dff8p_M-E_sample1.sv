module DFF_negclk_sync_reset #(parameter RESET_VAL = 1'b0) (
    input  wire clk,
    input  wire reset,
    input  wire d,
    output reg  q
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
    // Reset vector as parameterized constant
    localparam [7:0] RESET_VECTOR = 8'h34;

    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : dff_bits
            DFF_negclk_sync_reset #(
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