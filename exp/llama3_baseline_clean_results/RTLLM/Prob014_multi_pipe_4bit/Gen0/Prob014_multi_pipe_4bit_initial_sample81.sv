module multi_pipe_4bit(
    clk, 
    rst_n, 
    mul_a, 
    mul_b, 
    mul_out
);

parameter size = 4;

input clk;
input rst_n;
input [size-1:0] mul_a;
input [size-1:0] mul_b;
output reg [2*size-1:0] mul_out;

reg [2*size-1:0] reg1;
reg [2*size-1:0] reg2;

genvar i;
generate
    for (i = 0; i < size; i = i + 1) begin
        always @(posedge clk or negedge rst_n) begin
            if (~rst_n) begin
                reg1 <= 0;
                reg2 <= 0;
            end else begin
                if (i == 0) begin
                    if (mul_b[0]) begin
                        reg1 <= {size{1'b0}} << i | mul_a;
                    end else begin
                        reg1 <= 0;
                    end
                end else begin
                    if (mul_b[i]) begin
                        reg2 <= reg1 + ({size{1'b0}} << i | mul_a);
                    end else begin
                        reg2 <= reg1;
                    end
                end
            end
        end
    end
endgenerate

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        mul_out <= 0;
    end else begin
        mul_out <= reg2;
    end
end

endmodule