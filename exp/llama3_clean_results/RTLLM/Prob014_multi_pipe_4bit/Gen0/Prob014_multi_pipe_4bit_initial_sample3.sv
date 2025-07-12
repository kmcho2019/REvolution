module multi_pipe_4bit(
    input clk,
    input rst_n,
    input [3:0] mul_a,
    input [3:0] mul_b,
    output reg [7:0] mul_out
);

reg [7:0] mul_temp1;
reg [7:0] mul_temp2;
wire [7:0] partial_product [3:0];

integer i;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        mul_temp1 <= 8'd0;
        mul_temp2 <= 8'd0;
        mul_out <= 8'd0;
    end else begin
        for (i = 0; i < 4; i++) begin
            if (mul_b[i] == 1'b1) begin
                partial_product[i] = mul_a << i;
            end else begin
                partial_product[i] = 8'd0;
            end
        end
        
        mul_temp1 <= partial_product[0] + partial_product[1] + partial_product[2] + partial_product[3];
        mul_temp2 <= mul_temp1;
        
        mul_out <= mul_temp2;
    end
end

endmodule