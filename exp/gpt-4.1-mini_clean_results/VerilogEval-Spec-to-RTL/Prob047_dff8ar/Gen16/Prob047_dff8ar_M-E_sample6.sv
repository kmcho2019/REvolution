module SingleBitDFF_AR (
    input clk,
    input areset,
    input d,
    output reg q
);
    // Single-bit D flip-flop with async active-high reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            q <= 1'b0;
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

    // Instantiate 8 single-bit DFFs, one for each bit of d
    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : dff_array
            SingleBitDFF_AR dff_inst (
                .clk(clk),
                .areset(areset),
                .d(d[i]),
                .q(q[i])
            );
        end
    endgenerate

endmodule