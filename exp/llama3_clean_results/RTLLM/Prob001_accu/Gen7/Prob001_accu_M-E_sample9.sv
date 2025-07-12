module accu (
    input         clk, 
    input         rst_n, 
    input  [7:0]   data_in, 
    input         valid_in, 
    output        valid_out, 
    output [9:0]  data_out
);

reg [9:0] stage1, stage2, stage3, stage4;
reg        valid1, valid2, valid3, valid4;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        stage1 <= 10'd0;
        stage2 <= 10'd0;
        stage3 <= 10'd0;
        stage4 <= 10'd0;
        valid1 <= 1'b0;
        valid2 <= 1'b0;
        valid3 <= 1'b0;
        valid4 <= 1'b0;
    end else begin
        // Stage 1
        if (valid_in) begin
            stage1 <= data_in;
            valid1 <= 1'b1;
        end else begin
            stage1 <= 10'd0;
            valid1 <= 1'b0;
        end

        // Stage 2
        if (valid1) begin
            stage2 <= stage1 + data_in;
            valid2 <= 1'b1;
        end else begin
            stage2 <= 10'd0;
            valid2 <= 1'b0;
        end

        // Stage 3
        if (valid2) begin
            stage3 <= stage2 + data_in;
            valid3 <= 1'b1;
        end else begin
            stage3 <= 10'd0;
            valid3 <= 1'b0;
        end

        // Stage 4
        if (valid3) begin
            stage4 <= stage3 + data_in;
            valid4 <= 1'b1;
        end else begin
            stage4 <= 10'd0;
            valid4 <= 1'b0;
        end
    end
end

assign valid_out = valid4;
assign data_out = (valid4)? stage4 : 10'd0;

endmodule