module DFF_sync_reset (
    input       clk,
    input       reset,
    input       d,
    output reg  q
);
    always @(posedge clk) begin
        if (reset)
            q <= 1'b0;
        else
            q <= d;
    end
endmodule

module TopModule (
    input           clk,
    input           reset,
    input   [7:0]   d,
    output  [7:0]   q
);
    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : gen_dff
            DFF_sync_reset dff_inst (
                .clk(clk),
                .reset(reset),
                .d(d[i]),
                .q(q[i])
            );
        end
    endgenerate
endmodule