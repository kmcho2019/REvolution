// Parameterized vector D flip-flop module with active high asynchronous reset.
// Asynchronously resets output 'q' to 0 on 'areset' asserted high,
// and loads input 'd' on the rising edge of 'clk' otherwise.
module DFF_AsyncReset_Vector #(
    parameter integer WIDTH = 8  // Number of bits in the vector
) (
    input                   clk,     // Clock input (positive edge triggered)
    input                   areset,  // Asynchronous reset (active high)
    input  [WIDTH-1:0]      d,       // Data input vector
    output reg [WIDTH-1:0]  q = {WIDTH{1'b0}} // Data output vector, initialized to zero for simulation safety
);

    // Always block triggered on positive edge of clock or asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            q <= {WIDTH{1'b0}};  // Asynchronous reset to zero
        else
            q <= d;              // Load input data on clock edge
    end

endmodule

// Top-level module instantiating 8-bit vector DFF with asynchronous reset.
module TopModule (
    input         clk,    // Clock input
    input         areset, // Asynchronous reset input (active high)
    input  [7:0]  d,      // 8-bit data input
    output [7:0]  q       // 8-bit data output
);

    // Instantiate the parameterized 8-bit vector D flip-flop module
    DFF_AsyncReset_Vector #(
        .WIDTH(8)
    ) dff_inst (
        .clk(clk),
        .areset(areset),
        .d(d),
        .q(q)
    );

endmodule