// Shift Register module with active high asynchronous reset
module ShiftReg(
    input           clk,
    input           areset,
    input           d,
    output  [7:0]   q
);

    reg [7:0] q_reg;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            q_reg <= 8'b0;
        end else begin
            q_reg <= {d, q_reg[7:1]};
        end
    end

    assign q = q_reg;

endmodule

// TopModule using Shift Register
module TopModule(
    input           clk,
    input           areset,
    input   [7:0]   d,
    output  [7:0]   q
);

    // Instantiate Shift Register module
    ShiftReg shift_reg(.clk(clk), .areset(areset), .d(d[0]), .q(q));

endmodule