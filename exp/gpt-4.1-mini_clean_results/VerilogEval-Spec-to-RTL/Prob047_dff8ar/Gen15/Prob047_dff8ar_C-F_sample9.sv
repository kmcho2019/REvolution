// Parameterized single-bit D flip-flop with asynchronous active-high reset
module DFF_async_reset #(
    parameter WIDTH = 1
) (
    input                   clk,
    input                   areset,
    input  [WIDTH-1:0]      d,
    output reg [WIDTH-1:0]  q
);
    always @(posedge clk or posedge areset) begin
        if (areset)
            q <= {WIDTH{1'b0}};
        else
            q <= d;
    end
endmodule

// 8-bit vector register that internally uses the parameterized DFF_async_reset module
// for clarity and modularity, but implemented with a single always block for synthesis efficiency.
module DFF8_async_reset_vector (
    input         clk,
    input         areset,
    input  [7:0]  d,
    output [7:0]  q
);
    // Instantiate the parameterized single-bit DFF for the whole vector
    DFF_async_reset #(8) dff_vector (
        .clk(clk),
        .areset(areset),
        .d(d),
        .q(q)
    );
endmodule

module TopModule (
    input        clk,
    input        areset,
    input  [7:0] d,
    output [7:0] q
);
    // Instantiate the 8-bit asynchronous reset DFF vector
    DFF8_async_reset_vector dff8_inst (
        .clk(clk),
        .areset(areset),
        .d(d),
        .q(q)
    );
endmodule