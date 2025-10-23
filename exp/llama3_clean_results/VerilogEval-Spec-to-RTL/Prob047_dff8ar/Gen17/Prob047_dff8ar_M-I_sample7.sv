// Improved D Flip-Flop module with active high asynchronous reset and clock gating
module DFF_8bit(
    input           clk,
    input           areset,
    input           enable, // New enable signal for clock gating
    input   [7:0]   d,
    output  [7:0]   q
);

    // Use a reg to hold the output value
    reg [7:0] q_reg;

    // Always block triggered on positive edge of clk or posedge of areset
    always @(posedge clk or posedge areset) begin
        // If areset is high, reset q_reg to 0
        if (areset) begin
            q_reg <= 8'b0;
        end 
        // If enable is high, update q_reg with the input d on the positive edge of clk
        else if (enable) begin
            q_reg <= d;
        end
    end

    // Continuous assignment to output q
    assign q = q_reg;

endmodule

// Improved TopModule with a single 8-bit D Flip-Flop and clock gating
module TopModule(
    input           clk,
    input           areset,
    input           enable, // New enable signal for clock gating
    input   [7:0]   d,
    output  [7:0]   q
);

    // Instantiate the DFF_8bit module
    DFF_8bit dff(.clk(clk),.areset(areset),.enable(enable),.d(d),.q(q));

endmodule