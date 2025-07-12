// Refactored D Flip-Flop module with active high asynchronous reset
module DFF_8bit(
    input           clk,
    input           areset,
    input   [7:0]   d,
    output  [7:0]   q
);

    // Reg to hold the output value
    reg [7:0] q_reg;

    // Assign statement to handle asynchronous reset condition
    assign reset_val = (areset) ? 8'b0 : d;

    // Always block triggered only on the positive edge of clk
    always @(posedge clk) begin
        // Update q_reg with the input d on the positive edge of clk
        q_reg <= reset_val;
    end

    // Continuous assignment to output q
    assign q = q_reg;

endmodule

// Refactored TopModule with a single 8-bit D Flip-Flop
module TopModule(
    input           clk,
    input           areset,
    input   [7:0]   d,
    output  [7:0]   q
);

    // Instantiate the DFF_8bit module
    DFF_8bit dff(.clk(clk), .areset(areset), .d(d), .q(q));

endmodule