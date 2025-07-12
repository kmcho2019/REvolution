// Parameterized single-bit D flip-flop with asynchronous active-high reset
module DFF_AR_Single (
    input  wire clk,
    input  wire areset,
    input  wire d,
    output reg  q
);
    always @(posedge clk or posedge areset) begin
        if (areset)
            q <= 1'b0;
        else
            q <= d;
    end
endmodule

// Vectorized wrapper module that instantiates multiple single-bit DFF_AR_Single modules using generate
module DFF_AR_Vector #(
    parameter WIDTH = 8
) (
    input  wire               clk,
    input  wire               areset,
    input  wire [WIDTH-1:0]   d,
    output wire [WIDTH-1:0]   q
);
    genvar i;
    generate
        for (i = 0; i < WIDTH; i = i + 1) begin : dff_bits
            DFF_AR_Single dff_inst (
                .clk(clk),
                .areset(areset),
                .d(d[i]),
                .q(q[i])
            );
        end
    endgenerate
endmodule

// Top-level module instantiating the 8-bit vectorized DFF with asynchronous reset
module TopModule (
    input        clk,
    input        areset,
    input  [7:0] d,
    output [7:0] q
);
    DFF_AR_Vector #(.WIDTH(8)) dff_vector_inst (
        .clk(clk),
        .areset(areset),
        .d(d),
        .q(q)
    );
endmodule