module DFF_negclk_syncreset #(
    parameter INIT = 1'b0
) (
    input  wire clk,
    input  wire reset,
    input  wire d,
    output reg  q
);
    always @(negedge clk) begin
        if (reset)
            q <= INIT;
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
    // Constant reset value 0x34 = 8'b00110100
    localparam [7:0] RESET_VAL = 8'h34;

    // Instantiate 8 DFFs, each with synchronous reset and negative-edge triggered clock
    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : dff_array
            DFF_negclk_syncreset #(
                .INIT(RESET_VAL[i])
            ) dff_inst (
                .clk(clk),
                .reset(reset),
                .d(d[i]),
                .q(q[i])
            );
        end
    endgenerate
endmodule