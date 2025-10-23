module TopModule(
    input clk,
    input load,
    input ena,
    input [1:0] amount,
    input [63:0] data,
    output [63:0] q
);

reg [63:0] stage1;
reg [63:0] stage2;
reg [63:0] stage3;

// Stage 1: Load data
always @(posedge clk) begin
    if (load) begin
        stage1 <= data;
    end else begin
        stage1 <= stage1;
    end
end

// Stage 2: Shift data
always @(posedge clk) begin
    case (amount)
        2'b00: stage2 <= {stage1[62:0], 1'b0};
        2'b01: stage2 <= {stage1[55:0], 8'd0};
        2'b10: stage2 <= {stage1[63], stage1[63:1]};
        2'b11: stage2 <= {{8{stage1[63]}}, stage1[63:8]};
        default: stage2 <= stage1;
    endcase
end

// Stage 3: Enable and output
always @(posedge clk) begin
    if (ena) begin
        stage3 <= stage2;
    end else begin
        stage3 <= stage3;
    end
end

assign q = stage3;

endmodule