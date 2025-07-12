module DFF_AR (
    input clk,
    input areset,
    input d,
    output reg q
);
    always @(posedge clk or posedge areset) begin
        if (areset)
            q <= 1'b0;
        else
            q <= d;
    end
endmodule

module DFF_Vector_AR #(
    parameter WIDTH = 8
) (
    input                   clk,
    input                   areset,
    input  [WIDTH-1:0]      d,
    output [WIDTH-1:0]      q
);
    genvar i;
    generate
        for (i = 0; i < WIDTH; i = i + 1) begin : bit_dff
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
    // Instantiate the parameterized vector of single-bit asynchronous reset DFFs
    DFF_Vector_AR #(8) dff_vector (
        .clk(clk),
        .areset(areset),
        .d(d),
        .q(q)
    );
endmodule