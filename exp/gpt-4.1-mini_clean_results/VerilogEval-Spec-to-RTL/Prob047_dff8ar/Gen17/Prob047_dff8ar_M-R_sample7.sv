// Single-bit D flip-flop with asynchronous active-high reset
module DFF_AsyncReset (
    input  wire clk,
    input  wire areset,   // Asynchronous active-high reset
    input  wire d,
    output reg  q
);
    // Asynchronous reset and clock edge triggered register update
    always @(posedge clk or posedge areset) begin
        if (areset)
            q <= 1'b0;     // Reset output to zero asynchronously
        else
            q <= d;        // On clock edge, latch input data
    end
endmodule

module TopModule (
    input  wire        clk,
    input  wire        areset,
    input  wire [7:0]  d,
    output wire [7:0]  q
);
    genvar i;
    // Instantiate 8 individual 1-bit DFFs with async reset for each bit of d and q
    generate
        for (i = 0; i < 8; i = i + 1) begin : dff_gen
            DFF_AsyncReset dff_inst (
                .clk(clk),
                .areset(areset),
                .d(d[i]),
                .q(q[i])
            );
        end
    endgenerate
endmodule