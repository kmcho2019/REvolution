// Simplified TopModule with 8-bit D Flip-Flop
module TopModule(
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