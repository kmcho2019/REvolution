// Refactored D Flip-Flop module with active high asynchronous reset
module DFF_8bit(
    input           clk,
    input           areset,
    input   [7:0]   d,
    output  [7:0]   q
);

    reg [7:0] q_reg;

    // Directly drive output from internal register
    assign q = q_reg;

    // Use always block for clock and asynchronous reset logic
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            q_reg <= 8'b0;
        end else begin
            q_reg <= d;
        end
    end

endmodule

// TopModule remains unchanged
module TopModule(
    input           clk,
    input           areset,
    input   [7:0]   d,
    output  [7:0]   q
);

    DFF_8bit dff(.clk(clk), .areset(areset), .d(d), .q(q));

endmodule