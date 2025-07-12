// Parameterized vector D flip-flop with active high asynchronous reset.
// The flip-flops reset outputs to zero asynchronously on areset,
// and otherwise load input d on the positive edge of clk.
module DFF_AsyncReset_Vector #(
    parameter integer WIDTH = 8
) (
    input                   clk,
    input                   areset,
    input  [WIDTH-1:0]      d,
    output reg [WIDTH-1:0]  q
);
    // Asynchronous reset with non-blocking assignments ensures synthesis of proper FF reset ports.
    always @(posedge clk or posedge areset) begin
        if (areset)
            q <= {WIDTH{1'b0}};
        else
            q <= d;
    end
endmodule

// Top module instantiates the parameterized 8-bit vector DFF with asynchronous reset.
module TopModule (
    input         clk,
    input         areset,
    input  [7:0]  d,
    output [7:0]  q
);
    // Instantiate the vector DFF with asynchronous reset, width explicitly set to 8.
    DFF_AsyncReset_Vector #(
        .WIDTH(8)
    ) dff_inst (
        .clk(clk),
        .areset(areset),
        .d(d),
        .q(q)
    );
endmodule