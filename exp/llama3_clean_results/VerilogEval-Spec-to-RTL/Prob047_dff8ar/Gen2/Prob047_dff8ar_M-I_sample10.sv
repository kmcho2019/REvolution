// D Flip-Flop module with active high asynchronous reset
module DFF(
    input           clk,
    input           areset,
    input           d,
    output          q
);

    reg q_reg;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            q_reg <= 1'b0;
        end else begin
            q_reg <= d;
        end
    end

    assign q = q_reg;

endmodule

// TopModule with 8 D Flip-Flops using for-generate loop
module TopModule(
    input           clk,
    input           areset,
    input   [7:0]   d,
    output  [7:0]   q
);

    // Instantiate 8 DFF modules using for-generate loop
    genvar i;
    generate
        for (i = 0; i < 8; i++) begin
            DFF dff(.clk(clk), .areset(areset), .d(d[i]), .q(q[i]));
        end
    endgenerate

endmodule