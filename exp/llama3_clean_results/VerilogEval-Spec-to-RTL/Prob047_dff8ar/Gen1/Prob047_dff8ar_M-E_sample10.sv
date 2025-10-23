// D Flip-Flop module with active high asynchronous reset
module DFF(
    input           clk,
    input           areset,
    input           d,
    output          q
);

    reg q_reg;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            q_reg <= 1'b0;
        end else begin
            q_reg <= d;
        end
    end

    assign q = q_reg;

endmodule

// TopModule with 8 D Flip-Flops
module TopModule(
    input           clk,
    input           areset,
    input   [7:0]   d,
    output  [7:0]   q
);

    // Instantiate 8 DFF modules
    DFF dff0(clk, areset, d[0], q[0]);
    DFF dff1(clk, areset, d[1], q[1]);
    DFF dff2(clk, areset, d[2], q[2]);
    DFF dff3(clk, areset, d[3], q[3]);
    DFF dff4(clk, areset, d[4], q[4]);
    DFF dff5(clk, areset, d[5], q[5]);
    DFF dff6(clk, areset, d[6], q[6]);
    DFF dff7(clk, areset, d[7], q[7]);

endmodule