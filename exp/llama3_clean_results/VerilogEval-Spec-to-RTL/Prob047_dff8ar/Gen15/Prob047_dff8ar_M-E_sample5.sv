// Novel D Flip-Flop module with active high asynchronous reset
module DFF_8bit_novel(
    input           clk,
    input           areset,
    input   [7:0]   d,
    output  [7:0]   q
);

    reg [7:0] q_reg;

    // Separate always block for asynchronous reset
    always @(posedge areset) begin
        q_reg <= 8'b0;
    end

    // Separate always block for clock edge
    always @(posedge clk) begin
        if (!areset) begin
            q_reg <= d;
        end
    end

    // Continuous assignment for output
    assign q = q_reg;

endmodule

// TopModule remains the same for modularity and clarity
module TopModule_novel(
    input           clk,
    input           areset,
    input   [7:0]   d,
    output  [7:0]   q
);

    DFF_8bit_novel dff_novel(.clk(clk), .areset(areset), .d(d), .q(q));

endmodule