// Improved D Flip-Flop module with active high asynchronous reset
module DFF_8bit(
    input           clk,
    input           areset,
    input   [7:0]   d,
    output  [7:0]   q
);

    reg [7:0] q_reg = 8'b0; // Initialize with reset value

    // Simplified always block focusing on reset and clock edge
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            // Explicit reset handling to ensure q_reg resets to 0
            q_reg <= 8'b0;
        end else begin
            // Clock edge handling: update q_reg with input d
            q_reg <= d;
        end
    end

    // Assign output q to be continuously updated with q_reg
    assign q = q_reg;

endmodule

// TopModule remains the same for modularity and clarity
module TopModule(
    input           clk,
    input           areset,
    input   [7:0]   d,
    output  [7:0]   q
);

    // Instantiate DFF_8bit module
    DFF_8bit dff(.clk(clk), .areset(areset), .d(d), .q(q));

endmodule