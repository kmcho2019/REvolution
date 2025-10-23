// D Flip-Flop module with active high asynchronous reset
module DFF(
    input           clk,
    input           areset,
    input           d,
    output          q
);

    assign q = areset ? 1'b0 : (clk == 1'b1 ? d : q);

endmodule

// TopModule with 8 D Flip-Flops using for-generate
module TopModule(
    input           clk,
    input           areset,
    input   [7:0]   d,
    output  [7:0]   q
);

    // Instantiate 8 DFF modules using a for-generate loop
    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin
            DFF dff(clk, areset, d[i], q[i]);
        end
    endgenerate

endmodule