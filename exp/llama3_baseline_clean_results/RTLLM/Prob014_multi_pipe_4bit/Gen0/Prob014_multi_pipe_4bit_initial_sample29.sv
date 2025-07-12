module multi_pipe_4bit (
    input clk,
    input rst_n,
    input [3:0] mul_a,
    input [3:0] mul_b,
    output [7:0] mul_out
);

parameter size = 4;

reg [7:0] reg1;
reg [7:0] reg2;
reg [7:0] mul_out_reg;

integer i;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        reg1 <= 8'd0;
        reg2 <= 8'd0;
        mul_out_reg <= 8'd0;
    end else begin
        reg1 <= 8'd0;
        for (i = 0; i < size; i++) begin
            if (mul_b[i]) begin
                reg1 <= reg1 + (mul_a << i);
            end
        end
        reg2 <= reg1;
        mul_out_reg <= reg2;
    end
end

assign mul_out = mul_out_reg;

endmodule