// Single-bit D flip-flop with asynchronous active-high reset
module DFF_AsyncReset_Single (
    input  wire clk,
    input  wire areset,
    input  wire d,
    output reg  q
);
    always @(posedge clk or posedge areset) begin
        if (areset)
            q <= 1'b0;  // Reset output to zero asynchronously
        else
            q <= d;     // Latch input data on rising clock edge
    end
endmodule

module TopModule (
    input  wire        clk,
    input  wire        areset,
    input  wire [7:0]  d,
    output wire [7:0]  q
);
    // Generate 8 instances of single-bit DFFs with asynchronous reset
    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : dff_bits
            DFF_AsyncReset_Single dff_inst (
                .clk(clk),
                .areset(areset),
                .d(d[i]),
                .q(q[i])
            );
        end
    endgenerate
endmodule