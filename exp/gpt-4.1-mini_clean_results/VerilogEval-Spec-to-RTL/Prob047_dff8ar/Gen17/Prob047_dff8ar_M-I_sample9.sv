// Parameterized vector D flip-flop module with active high asynchronous reset.
// Adds internal clock enable by updating output only when input data differs from current output.
// This reduces unnecessary toggling and lowers dynamic power without changing external interface.
module DFF_AsyncReset_Vector #(
    parameter integer WIDTH = 8  // Number of bits in the vector
) (
    input                   clk,     // Clock input (positive edge triggered)
    input                   areset,  // Asynchronous reset (active high)
    input  [WIDTH-1:0]      d,       // Data input vector
    output reg [WIDTH-1:0]  q = {WIDTH{1'b0}} // Data output vector, initialized to zero for simulation safety
);

    wire ce; // clock enable: update only if input differs from output

    assign ce = (d != q);  // enable update only if input data is different from current output

    always @(posedge clk or posedge areset) begin
        if (areset)
            q <= {WIDTH{1'b0}};  // Asynchronous reset to zero
        else if (ce)
            q <= d;              // Load input data on clock edge only if data changed
        // else retain current q value, avoiding unnecessary toggling
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