// Refactored D Flip-Flop module with active high asynchronous reset
module DFF_8bit(
    input           clk,
    input           areset,
    input   [7:0]   d,
    output  [7:0]   q
);

    // Explicitly sized reg declaration for internal register
    reg [7:0] q_reg;

    // Always block triggered on positive edge of clk
    always @(posedge clk) begin
        // If areset is high, reset q_reg to 0; otherwise, update q_reg with the input d
        if (areset) begin
            q_reg <= 8'b0;
        end else begin
            q_reg <= d;
        end
    end

    // Continuous assignment to output q, considering asynchronous reset
    assign q = (areset) ? 8'b0 : q_reg;

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