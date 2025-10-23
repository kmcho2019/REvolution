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
reg [2*size-1:0] reg_product;
reg [size-1:0] count;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        reg_a <= {size{1'b0}}; // Corrected initialization
        reg_b <= {size{1'b0}}; // Corrected initialization
        reg_sum <= {2*size{1'b0}};
        reg_product <= {2*size{1'b0}};
        count <= {size{1'b0}};
    end else begin
        if (count == {size{1'b0}}) begin
            reg_a <= {size{1'b0}, mul_a}; // Extended with size zeros
            reg_b <= {size{1'b0}, mul_b}; // Extended with size zeros
            reg_sum <= {2*size{1'b0}};
            count <= count + 1'd1;
        end else if (count < size) begin
            if (reg_b[count-1] == 1'b1) begin
                reg_sum <= reg_sum + (reg_a << (count-1));
            end
            count <= count + 1'd1;
        end else begin
            reg_product <= reg_sum;
        end
    end
end

always @(posedge clk) begin
    if (count == size) begin
        mul_out <= reg_product;
    end
end

endmodule