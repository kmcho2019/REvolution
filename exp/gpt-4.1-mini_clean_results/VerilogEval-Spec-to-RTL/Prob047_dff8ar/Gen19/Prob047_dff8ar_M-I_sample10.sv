// Parameterized vector D flip-flop with active high asynchronous reset.
// Updates output q on rising clock edge only when input d differs from q,
// reducing unnecessary toggling and saving dynamic power.
// On asynchronous reset asserted high, output q resets to zero.
module DFF_AsyncReset_Vector #(
    parameter integer WIDTH = 8
) (
    input                   clk,
    input                   areset,
    input  [WIDTH-1:0]      d,
    output reg [WIDTH-1:0]  q
);
    // No initial block: rely on asynchronous reset and synthesis initialization

    always @(posedge clk or posedge areset) begin
        if (areset)
            q <= {WIDTH{1'b0}};
        else if (d != q)     // Update q only if input d differs from current q
            q <= d;
        // else q retains its previous value, avoiding unnecessary toggling
    end
endmodule

// TopModule instantiates an 8-bit vector DFF with asynchronous reset and
// internal update gating to minimize toggling and power consumption.
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