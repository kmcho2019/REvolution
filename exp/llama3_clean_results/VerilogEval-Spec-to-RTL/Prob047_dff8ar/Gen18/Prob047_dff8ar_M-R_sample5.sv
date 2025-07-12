// Refactored TopModule using direct D flip-flop instantiation
module TopModule(
    input           clk,
    input           areset,
    input   [7:0]   d,
    output  [7:0]   q
);

    reg [7:0] q_reg; // Register to hold the output values

    // Assign the output
    assign q = q_reg;

    // D flip-flop logic with asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            q_reg <= 8'b0; // Reset to 0 on asynchronous reset
        end else begin
            q_reg <= d; // Load input d on positive edge of clk
        end
    end

endmodule