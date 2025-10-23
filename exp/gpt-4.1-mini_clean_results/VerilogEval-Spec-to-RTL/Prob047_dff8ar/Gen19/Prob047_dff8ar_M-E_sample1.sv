// Single-bit D Flip-Flop with asynchronous active-high reset
module DFF_AR (
    input       clk,
    input       areset,
    input       d,
    output reg  q
);
    always @(posedge clk or posedge areset) begin
        if (areset)
            q <= 1'b0;
        else
            q <= d;
    end
endmodule

// TopModule instantiating 8 individual DFF_AR flip-flops
module TopModule (
    input        clk,
    input        areset,
    input  [7:0] d,
    output [7:0] q
);
    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : bit_dffs
            DFF_AR dff_inst (
                .clk(clk),
                .areset(areset),
                .d(d[i]),
                .q(q[i])
            );
        end
    endgenerate
endmodule