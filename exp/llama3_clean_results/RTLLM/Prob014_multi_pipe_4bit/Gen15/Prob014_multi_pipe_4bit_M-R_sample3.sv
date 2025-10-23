module multi_pipe_4bit #(
    parameter size = 4
)(
    input clk,
    input rst_n,
    input [size-1:0] mul_a,
    input [size-1:0] mul_b,
    output reg [2*size-1:0] mul_out
);

reg [2*size-1:0] reg_a;
reg [2*size-1:0] reg_b;
reg [2*size-1:0] reg_sum;
reg [size-1:0] count;

always_ff @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        reg_a <= {size{1'b0}};
        reg_b <= {size{1'b0}};
        reg_sum <= {2*size{1'b0}};
        count <= 'd0;
    end else begin
        if (count == 'd0) begin
            reg_a <= {size{1'b0}, mul_a};
            reg_b <= {size{1'b0}, mul_b};
            reg_sum <= {2*size{1'b0}};
            count <= count + 1;
        end else if (count < size) begin
            if (reg_b[count-1] == 1'b1) begin
                reg_sum <= reg_sum + (reg_a << (count-1));
            end
            count <= count + 1;
        end else begin
            count <= 'd0;
        end
    end
end

always_ff @(posedge clk) begin
    if (count == size) begin
        mul_out <= reg_sum;
    end
end

endmodule