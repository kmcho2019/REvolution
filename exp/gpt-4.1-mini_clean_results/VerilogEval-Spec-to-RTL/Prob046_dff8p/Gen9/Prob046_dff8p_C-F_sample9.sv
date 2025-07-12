module DFF #(
    parameter RESET_VALUE = 1'b0
) (
    input  clk,
    input  reset,
    input  d,
    output reg q
);
    // Synchronous active-high reset to RESET_VALUE on negedge clk
    always @(negedge clk) begin
        if (reset)
            q <= RESET_VALUE;
        else
            q <= d;
    end
endmodule

module TopModule (
    input        clk,
    input        reset,
    input  [7:0] d,
    output [7:0] q
);

    localparam [7:0] RESET_VAL = 8'h34;

    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : dffs
            DFF #(.RESET_VALUE(RESET_VAL[i])) dff_inst (
                .clk(clk),
                .reset(reset),
                .d(d[i]),
                .q(q[i])
            );
        end
    endgenerate

endmodule