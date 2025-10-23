// Refactored D Flip-Flop module with active high asynchronous reset
module DFF_8bit(
    input           clk,
    input           areset,
    input   [7:0]   d,
    output  [7:0]   q
);

    reg [7:0] q_reg;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            // Asynchronous reset to zero
            q_reg <= 8'b0;
        end else begin
            // D flip-flop functionality on positive clock edge
            q_reg <= d;
        end
    end

    // Continuous assignment for output
    assign q = q_reg;

endmodule

// Refactored TopModule with a single 8-bit D Flip-Flop
module TopModule(
    input           clk,
    input           areset,
    input   [7:0]   d,
    output  [7:0]   q
);

    // Instantiate the 8-bit D flip-flop
    DFF_8bit dff(
        .clk(clk),
        .areset(areset),
        .d(d),
        .q(q)
    );

endmodule