module DFF_AR (
    input        clk,
    input        areset,
    input        d,
    output reg   q
);
    // Single-bit D Flip-Flop with active-high asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            q <= 1'b0;
        else
            q <= d;
    end
endmodule

module DFF8_AR (
    input         clk,
    input         areset,
    input  [7:0]  d,
    output [7:0]  q
);
    // Internally instantiate 8 single-bit DFF_AR flip-flops using generate
    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : gen_dffs
            DFF_AR dff_inst (
                .clk(clk),
                .areset(areset),
                .d(d[i]),
                .q(q[i])
            );
        end
    endgenerate
endmodule

module TopModule (
    input         clk,
    input         areset,
    input  [7:0]  d,
    output [7:0]  q
);
    // Instantiate the 8-bit DFF vector module with async reset
    DFF8_AR dff8_inst (
        .clk(clk),
        .areset(areset),
        .d(d),
        .q(q)
    );
endmodule