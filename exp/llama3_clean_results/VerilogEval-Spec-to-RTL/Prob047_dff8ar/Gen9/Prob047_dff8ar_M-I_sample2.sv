// Improved D Flip-Flop module with active high asynchronous reset
module DFF_8bit(
    input           clk,
    input           areset,
    input   [7:0]   d,
    output  [7:0]   q
);

    // Use a reg to hold the output value
    reg [7:0] q_reg;

    // Always block triggered on positive edge of areset
    always @(posedge areset) begin
        // Reset q_reg to 0
        q_reg <= 8'b0;
    end

    // Always block triggered on positive edge of clk
    always @(posedge clk) begin
        // Update q_reg with the input d
        q_reg <= d;
    end

    // Continuous assignment to output q
    assign q = q_reg;

endmodule

// Improved TopModule with a single 8-bit D Flip-Flop
module TopModule(
    input           clk,
    input           areset,
    input   [7:0]   d,
    output  [7:0]   q
);

    // Instantiate the DFF_8bit module
    DFF_8bit dff(.clk(clk), .areset(areset), .d(d), .q(q));

endmodule