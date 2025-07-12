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

// 4-bit D Flip-Flop module with active high asynchronous reset
module DFF4(
    input           clk,
    input           areset,
    input   [3:0]   d,
    output  [3:0]   q
);

    DFF dff0(.clk(clk), .areset(areset), .d(d[0]), .q(q[0]));
    DFF dff1(.clk(clk), .areset(areset), .d(d[1]), .q(q[1]));
    DFF dff2(.clk(clk), .areset(areset), .d(d[2]), .q(q[2]));
    DFF dff3(.clk(clk), .areset(areset), .d(d[3]), .q(q[3]));

endmodule

// Pipeline Stage module
module PipelineStage(
    input           clk,
    input           areset,
    input   [3:0]   d,
    output  [3:0]   q
);

    DFF4 dff4(.clk(clk), .areset(areset), .d(d), .q(q));

endmodule

// TopModule with pipeline stages
module TopModule(
    input           clk,
    input           areset,
    input   [7:0]   d,
    output  [7:0]   q
);

    reg [3:0] stage1_q;

    PipelineStage stage1(.clk(clk), .areset(areset), .d(d[3:0]), .q(stage1_q));
    PipelineStage stage2(.clk(clk), .areset(areset), .d(d[7:4]), .q(q[7:4]));

    assign q[3:0] = stage1_q;

endmodule