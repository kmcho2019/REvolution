// 4-bit Pipeline Stage module with active high asynchronous reset
module PipelineStage4bit(
    input           clk,
    input           areset,
    input   [3:0]   d,
    output  [3:0]   q
);

    reg [3:0] q_reg;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            q_reg <= 4'b0;
        end else begin
            q_reg <= d;
        end
    end

    assign q = q_reg;

endmodule

// 8-bit Pipeline module with active high asynchronous reset
module PipelineStage8bit(
    input           clk,
    input           areset,
    input   [7:0]   d,
    output  [7:0]   q
);

    wire [3:0] mid;

    PipelineStage4bit ps1(.clk(clk),.areset(areset),.d(d[7:4]),.q(mid));
    PipelineStage4bit ps2(.clk(clk),.areset(areset),.d(d[3:0]),.q(q[3:0]));

    assign q[7:4] = mid;

endmodule

// TopModule with a single 8-bit Pipeline Stage
module TopModule(
    input           clk,
    input           areset,
    input   [7:0]   d,
    output  [7:0]   q
);

    PipelineStage8bit ps(.clk(clk),.areset(areset),.d(d),.q(q));

endmodule