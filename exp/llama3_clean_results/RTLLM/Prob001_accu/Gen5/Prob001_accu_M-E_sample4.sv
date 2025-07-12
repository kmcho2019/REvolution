module accu (
    input         clk, 
    input         rst_n, 
    input  [7:0]   data_in, 
    input         valid_in, 
    output        valid_out, 
    output [9:0]  data_out
);

reg [9:0] stage1, stage2, stage3, stage4;
reg [1:0] counter;
reg        valid_out_reg;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        stage1 <= 10'd0;
        stage2 <= 10'd0;
        stage3 <= 10'd0;
        stage4 <= 10'd0;
        counter <= 2'd0;
        valid_out_reg <= 1'b0;
    end else begin
        if (valid_in) begin
            stage1 <= (counter == 2'd0)? {2'd0, data_in} : stage1;
            stage2 <= (counter == 2'd1)? stage1 + {2'd0, data_in} : stage2;
            stage3 <= (counter == 2'd2)? stage2 + {2'd0, data_in} : stage3;
            stage4 <= (counter == 2'd3)? stage3 + {2'd0, data_in} : stage4;
            counter <= (counter == 2'd3)? 2'd0 : counter + 1'd1;
            valid_out_reg <= (counter == 2'd3)? 1'b1 : 1'b0;
        end else begin
            stage1 <= stage1;
            stage2 <= stage2;
            stage3 <= stage3;
            stage4 <= stage4;
            counter <= counter;
            valid_out_reg <= (valid_out_reg &&!valid_in)? 1'b0 : valid_out_reg;
        end
    end
end

assign valid_out = valid_out_reg;
assign data_out = (valid_out_reg)? stage4 : 10'd0;

endmodule