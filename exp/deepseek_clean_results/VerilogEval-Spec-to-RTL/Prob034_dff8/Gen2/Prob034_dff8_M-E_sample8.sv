module TopModule (
    input clk,
    input [7:0] d,
    output [7:0] q
);

    // Generate 8 individual D flip-flops
    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : dff_gen
            d_flip_flop dff_inst (
                .clk(clk),
                .d(d[i]),
                .q(q[i])
            );
        end
    endgenerate

endmodule

// Single-bit D flip-flop module
module d_flip_flop (
    input clk,
    input d,
    output reg q
);
    always @(posedge clk) begin
        q <= d;
    end
endmodule