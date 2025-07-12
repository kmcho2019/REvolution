module multi_pipe_4bit (
    input clk,
    input rst_n,
    input [3:0] mul_a,
    input [3:0] mul_b,
    output reg [7:0] mul_out
);

parameter size = 4;

reg [7:0] partial_product [3:0];
reg [7:0] reg1;
reg [7:0] reg2;

integer i;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        reg1 <= 8'd0;
        reg2 <= 8'd0;
        mul_out <= 8'd0;
    end else begin
        for (i = 0; i < size; i++) begin
            if (mul_b[i]) begin
                partial_product[i] <= {4'd0, mul_a} << i;
            end else begin
                partial_product[i] <= 8'd0;
            end
        end
        
        reg1 <= partial_product[0] + partial_product[1];
        reg2 <= reg1 + partial_product[2] + partial_product[3];
        
        mul_out <= reg2;
    end
end

endmodule