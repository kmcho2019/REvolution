// D Flip-Flop module with active high asynchronous reset
module DFF(
    input           clk,
    input           areset,
    input           d,
    output reg      q
);

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            q <= 1'b0;
        end else begin
            q <= d;
        end
    end

endmodule

// TopModule with 8 D Flip-Flops
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