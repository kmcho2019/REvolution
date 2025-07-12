module right_shifter(
    input clk,  // Clock signal
    input d,    // Input signal to be right-shifted
    output reg [7:0] q  // Output signal representing the result of the right shift operation
);

reg [7:0] stage1, stage2, stage3, stage4, stage5, stage6, stage7;

always @(posedge clk) begin
    stage1 <= {d, 7'b0};
    stage2 <= {stage1[0], stage1[7:1]};
    stage3 <= {stage2[0], stage2[7:1]};
    stage4 <= {stage3[0], stage3[7:1]};
    stage5 <= {stage4[0], stage4[7:1]};
    stage6 <= {stage5[0], stage5[7:1]};
    stage7 <= {stage6[0], stage6[7:1]};
    q <= stage7;
end

initial begin
    stage1 = 8'd0;
    stage2 = 8'd0;
    stage3 = 8'd0;
    stage4 = 8'd0;
    stage5 = 8'd0;
    stage6 = 8'd0;
    stage7 = 8'd0;
    q = 8'd0;
end

endmodule