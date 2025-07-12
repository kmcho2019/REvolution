// D Flip-Flop module with active high asynchronous reset
module DFF(
    input           clk,
    input           areset,
    input           en,
    input           d,
    output          q
);

    reg q_reg;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            q_reg <= 1'b0;
        end else if (en) begin
            q_reg <= d;
        end
    end

    assign q = q_reg;

endmodule

// TopModule with 8 D flip-flops
module TopModule(
    input           clk,
    input           areset,
    input   [7:0]   d,
    output  [7:0]   q
);

    wire [7:0] q_int;

    generate
        for (genvar i = 0; i < 8; i++) begin
            DFF dff(.clk(clk), .areset(areset), .en(1'b1), .d(d[i]), .q(q_int[i]));
        end
    endgenerate

    assign q = q_int;

endmodule