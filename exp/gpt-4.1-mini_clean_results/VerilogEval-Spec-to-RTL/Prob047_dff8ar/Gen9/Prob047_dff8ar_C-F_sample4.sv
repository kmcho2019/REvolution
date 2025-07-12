module DFF_AR #(
    parameter WIDTH = 1
) (
    input                   clk,
    input                   areset,
    input  [WIDTH-1:0]      d,
    output reg [WIDTH-1:0]  q
);
    // Parameterized DFF with async active-high reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            q <= {WIDTH{1'b0}};
        else
            q <= d;
    end
endmodule

module TopModule (
    input        clk,
    input        areset,
    input  [7:0] d,
    output [7:0] q
);

    // Instantiate the vectorized 8-bit DFF with async reset
    DFF_AR #(8) dff_vector (
        .clk(clk),
        .areset(areset),
        .d(d),
        .q(q)
    );

endmodule