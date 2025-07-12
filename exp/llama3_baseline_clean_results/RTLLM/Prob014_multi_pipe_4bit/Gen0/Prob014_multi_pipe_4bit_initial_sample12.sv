module multi_pipe_4bit (
    input clk,
    input rst_n,
    input [3:0] mul_a,
    input [3:0] mul_b,
    output reg [7:0] mul_out
);

parameter size = 4;

reg [7:0] reg1;
reg [7:0] reg2;

// Generate block to perform multiplication for each bit position of the multiplier
genvar i;
generate
    for (i = 0; i < size; i = i + 1) begin
        wire [7:0] partial_product;
        assign partial_product = (mul_b[i] == 1'b1) ? {4'b0, mul_a} << i : 8'b0;
        
        if (i == 0) begin
            always @(posedge clk or negedge rst_n) begin
                if (~rst_n) begin
                    reg1 <= 8'b0;
                end else begin
                    reg1 <= partial_product;
                end
            end
        end else begin
            reg [7:0] reg_temp;
            always @(posedge clk or negedge rst_n) begin
                if (~rst_n) begin
                    reg_temp <= 8'b0;
                end else begin
                    reg_temp <= reg1 + partial_product;
                end
            end
            always @(posedge clk or negedge rst_n) begin
                if (~rst_n) begin
                    reg1 <= 8'b0;
                end else begin
                    reg1 <= reg_temp;
                end
            end
        end
    end
endgenerate

// Final product calculation
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        mul_out <= 8'b0;
    end else begin
        mul_out <= reg1;
    end
end

endmodule