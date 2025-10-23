// Improved D Flip-Flop module with active high asynchronous reset
module DFF_8bit(
    input           clk,
    input           areset,
    input   [7:0]   d,
    output  [7:0]   q
);

    reg [7:0] q_reg = 8'b0; // Initialize with reset value

    always @(posedge clk or posedge areset) begin
        if (areset) begin // Explicitly handle reset at the beginning
            q_reg <= 8'b0;
        end else if (clk) begin // Ensure clock condition for non-reset case
            q_reg <= d;
        end
    end

    assign q = q_reg;

endmodule

// TopModule remains unchanged as it simply instantiates DFF_8bit
module TopModule(
    input           clk,
    input           areset,
    input   [7:0]   d,
    output  [7:0]   q
);

    DFF_8bit dff(.clk(clk), .areset(areset), .d(d), .q(q));

endmodule