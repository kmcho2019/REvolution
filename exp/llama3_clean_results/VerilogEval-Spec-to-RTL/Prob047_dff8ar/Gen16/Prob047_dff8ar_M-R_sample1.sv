// Refactored D Flip-Flop module with active high asynchronous reset
module DFF_8bit(
    input           clk,
    input           areset,
    input   [7:0]   d,
    output  [7:0]   q
);

    reg [7:0] q_reg = 8'b0; // Initialize with reset value

    // Asynchronous reset logic
    assign q = areset ? 8'b0 : q_reg;

    // Clock edge logic
    always @(posedge clk) begin
        if (!areset) begin
            q_reg <= d; // Update internal register on clock edge
        end
    end

endmodule

// TopModule remains the same for modularity and clarity
module TopModule(
    input           clk,
    input           areset,
    input   [7:0]   d,
    output  [7:0]   q
);

    DFF_8bit dff(.clk(clk), .areset(areset), .d(d), .q(q));

endmodule