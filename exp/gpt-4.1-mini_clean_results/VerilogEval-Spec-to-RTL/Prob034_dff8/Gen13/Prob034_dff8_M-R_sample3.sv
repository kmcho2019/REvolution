module TopModule (
    input        clk,
    input  [7:0] d,
    output [7:0] q
);

    // Generate eight D flip-flops, one for each bit of d/q
    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : dff_bits
            DFF dff_inst (
                .clk(clk),
                .d(d[i]),
                .q(q[i])
            );
        end
    endgenerate

endmodule

// Simple positive edge-triggered D flip-flop module
module DFF (
    input  clk,
    input  d,
    output reg q
);
    always @(posedge clk) begin
        q <= d;
    end
endmodule