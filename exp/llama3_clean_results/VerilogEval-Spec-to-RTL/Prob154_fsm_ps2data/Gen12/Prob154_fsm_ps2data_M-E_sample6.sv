module TopModule(
    input clk,
    input reset,
    input [7:0] in,
    output reg [23:0] out_bytes,
    output reg done
);

reg [7:0] stage1, stage2, stage3;
reg start_msg;

always @(posedge clk) begin
    if (reset) begin
        stage1 <= 8'b0;
        stage2 <= 8'b0;
        stage3 <= 8'b0;
        start_msg <= 1'b0;
        out_bytes <= 24'b0;
        done <= 1'b0;
    end else begin
        // Stage 1: Buffer input byte
        stage1 <= in;

        // Stage 2: Detect message boundary
        if (stage1[3] == 1'b1) begin
            start_msg <= 1'b1;
        end else if (stage2[3] == 1'b1 || stage3[3] == 1'b1) begin
            start_msg <= 1'b0;
        end

        // Pipeline shift
        stage2 <= stage1;
        stage3 <= stage2;

        // Output stage
        if (start_msg && stage3 != 8'b0) begin
            out_bytes <= {stage3, stage2, stage1};
            done <= 1'b1;
        end else begin
            done <= 1'b0;
        end
    end
end

endmodule