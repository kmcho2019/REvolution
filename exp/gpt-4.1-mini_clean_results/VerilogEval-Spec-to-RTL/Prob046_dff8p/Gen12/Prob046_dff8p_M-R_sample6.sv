module DFF_sync_reset_negclk #(
    parameter RESET_VAL = 1'b0
) (
    input       clk,
    input       reset,
    input       d,
    output reg  q
);
    // Single bit negative edge triggered DFF with synchronous active high reset
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
    // Internal wires for gated inputs: pass d[i] only if d[i] != q[i] to reduce toggling
    wire [7:0] d_gated;

    genvar i;
    generate
        for (i=0; i<8; i=i+1) begin : gen_dff
            // Reset bits of 0x34 = 8'b00110100 = b7..b0
            // bit positions: [7]=0, [6]=0, [5]=1, [4]=1, [3]=0, [2]=1, [1]=0, [0]=0
            localparam bit [7:0] RESET_PATTERN = 8'b00110100;
            // Gate d input to avoid unnecessary toggling
            assign d_gated[i] = (d[i] != q[i]) ? d[i] : q[i];

            DFF_sync_reset_negclk #(
                .RESET_VAL(RESET_PATTERN[i])
            ) dff_inst (
                .clk(clk),
                .reset(reset),
                .d(d_gated[i]),
                .q(q[i])
            );
        end
    endgenerate
endmodule