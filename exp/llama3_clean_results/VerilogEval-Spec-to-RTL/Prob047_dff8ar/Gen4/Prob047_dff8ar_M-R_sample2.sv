// Refactored D Flip-Flop module with active high asynchronous reset
module DFF(
    input           clk,
    input           areset,
    input           d,
    output          q
);

    reg q_reg;

    // Directly assign reset condition
    assign q_reg = areset ? 1'b0 : (q_reg == 1'bz) ? 1'b0 : q_reg;

    // Always block for clock edge
    always @(posedge clk) begin
        if (!areset) begin
            q_reg <= d;
        end
    end

    assign q = q_reg;

endmodule

// TopModule with 8 D Flip-Flops remains the same
module TopModule(
    input           clk,
    input           areset,
    input   [7:0]   d,
    output  [7:0]   q
);

    // Instantiate 8 DFF modules using a for-generate loop
    genvar i;
    generate
        for (i = 0; i < 8; i++) begin
            DFF dff(clk, areset, d[i], q[i]);
        end
    endgenerate

endmodule