// Improved D Flip-Flop module with active high asynchronous reset and clock enable
module DFF_8bit(
    input           clk,
    input           areset,
    input           clk_en,  // Clock enable
    input   [7:0]   d,
    output  [7:0]   q
);

    reg [7:0] q_reg;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            q_reg <= 8'b0;
        end else if (clk_en) begin
            q_reg <= d;
        end
    end

    assign q = q_reg;

endmodule

// TopModule with clock enable generation
module TopModule(
    input           clk,
    input           areset,
    input   [7:0]   d,
    output  [7:0]   q
);

    wire clk_en;  // Clock enable

    // Simple clock enable generation (e.g., every other clock cycle)
    reg clk_en_reg;
    always @(posedge clk) begin
        clk_en_reg <= ~clk_en_reg;
    end
    assign clk_en = clk_en_reg;

    DFF_8bit dff(.clk(clk), .areset(areset), .clk_en(clk_en), .d(d), .q(q));

endmodule