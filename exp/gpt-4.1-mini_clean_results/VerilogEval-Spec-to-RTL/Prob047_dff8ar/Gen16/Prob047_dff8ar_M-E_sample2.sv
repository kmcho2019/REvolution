// Single-bit D flip-flop with active high asynchronous reset.
// Asynchronously resets output q to 0 on areset asserted high,
// else captures input d on the rising edge of clk.
module DFF_AsyncReset_Single (
    input  wire clk,     // Clock input (posedge triggered)
    input  wire areset,  // Asynchronous reset (active high)
    input  wire d,       // Data input
    output reg  q        // Data output
);

    always @(posedge clk or posedge areset) begin
        if (areset)
            q <= 1'b0;   // Asynchronous reset to 0
        else
            q <= d;      // Capture input on clock edge
    end

endmodule

// TopModule that instantiates 8 individual single-bit DFFs with async reset,
// one per bit of the 8-bit vector inputs and outputs.
module TopModule (
    input         clk,    // Clock input
    input         areset, // Active high asynchronous reset
    input  [7:0]  d,      // 8-bit data input
    output [7:0]  q       // 8-bit data output
);

    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : DFF_BITS
            DFF_AsyncReset_Single dff_inst (
                .clk(clk),
                .areset(areset),
                .d(d[i]),
                .q(q[i])
            );
        end
    endgenerate

endmodule