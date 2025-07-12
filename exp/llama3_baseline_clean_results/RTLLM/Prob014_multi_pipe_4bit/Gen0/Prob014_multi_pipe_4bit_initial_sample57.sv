module multi_pipe_4bit(
    input clk,
    input rst_n,
    input [3:0] mul_a,
    input [3:0] mul_b,
    output [7:0] mul_out
);

reg [7:0] mul_a_ext;
reg [7:0] mul_b_ext;
reg [7:0] partial_product [3:0];
reg [7:0] sum_reg1 [3:0];
reg [7:0] sum_reg2;
reg [7:0] final_product;

assign mul_a_ext = {4'b0000, mul_a};
assign mul_b_ext = {4'b0000, mul_b};

genvar i;
generate
    for(i = 0; i < 4; i = i + 1) begin
        always @(posedge clk or negedge rst_n) begin
            if(~rst_n) begin
                partial_product[i] <= 8'd0;
            end else if(mul_b_ext[i] == 1'b1) begin
                partial_product[i] <= mul_a_ext << i;
            end else begin
                partial_product[i] <= 8'd0;
            end
        end
    end
endgenerate

always @(posedge clk or negedge rst_n) begin
    if(~rst_n) begin
        sum_reg1 <= '{default: 8'd0};
    end else begin
        sum_reg1[0] <= partial_product[0];
        sum_reg1[1] <= partial_product[1];
        sum_reg1[2] <= partial_product[2];
        sum_reg1[3] <= partial_product[3];
    end
end

always @(posedge clk or negedge rst_n) begin
    if(~rst_n) begin
        sum_reg2 <= 8'd0;
    end else begin
        sum_reg2 <= sum_reg1[0] + sum_reg1[1] + sum_reg1[2] + sum_reg1[3];
    end
end

always @(posedge clk or negedge rst_n) begin
    if(~rst_n) begin
        final_product <= 8'd0;
    end else begin
        final_product <= sum_reg2;
    end
end

assign mul_out = final_product;

endmodule