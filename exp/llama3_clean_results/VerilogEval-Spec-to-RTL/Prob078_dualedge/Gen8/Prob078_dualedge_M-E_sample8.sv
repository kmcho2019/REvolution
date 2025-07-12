module TopModule(
    input clk,
    input d,
    output reg q
);

reg clk_edge;  // Toggle flip-flop to detect clock edges
reg q_reg;     // Main flip-flop to store the output

// Toggle flip-flop to detect clock edges
always @(posedge clk or negedge clk) begin
    clk_edge <= ~clk_edge;
end

// Main flip-flop to store the output
always @(posedge clk_edge) begin
    q_reg <= d;
end

// Assign the output of the main flip-flop to the output port
assign q = q_reg;

endmodule