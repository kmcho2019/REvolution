// Parameterized vector D flip-flop with active high asynchronous reset.
// On areset (asynchronously asserted high), output q resets to zero.
// On the rising edge of clk (when areset is low), q captures input d.
// Non-blocking assignments ensure proper synthesis and simulation semantics.
module DFF_AsyncReset_Vector #(
    parameter integer WIDTH = 8
) (
    input                   clk,
    input                   areset,
    input  [WIDTH-1:0]      d,
    output reg [WIDTH-1:0]  q
);
    // Initialize q to 0 to avoid X states in simulation
    initial q = {WIDTH{1'b0}};

    always @(posedge clk or posedge areset) begin
        if (areset)
            q <= {WIDTH{1'b0}};
        else
            q <= d;
    end
endmodule

// TopModule instantiates an 8-bit vector DFF with asynchronous reset.
module TopModule (
    input         clk,    // Clock input, positive edge triggered
    input         areset, // Active high asynchronous reset
    input  [7:0]  d,      // Data input bus
    output [7:0]  q       // Data output bus
);
    // Instantiate the parameterized DFF vector with explicit 8-bit width
    DFF_AsyncReset_Vector #(
        .WIDTH(8)
    ) dff_inst (
        .clk(clk),
        .areset(areset),
        .d(d),
        .q(q)
    );
endmodule