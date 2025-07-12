module multi_pipe_4bit #(
    parameter size = 4
)(
    input clk,
    input rst_n,
    input [size-1:0] mul_a,
    input [size-1:0] mul_b,
    output reg [2*size-1:0] mul_out
);

reg [2*size-1:0] partial_products [size-1:0];
reg [2*size-1:0] sum;
reg [2*size-1:0] final_sum;

integer i;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        for (i = 0; i < size; i++) begin
            partial_products[i] <= {2*size{1'b0}};
        end
        sum <= {2*size{1'b0}};
        final_sum <= {2*size{1'b0}};
    end else begin
        for (i = 0; i < size; i++) begin
            if (mul_b[i] == 1'b1) begin
                partial_products[i] <= {size{1'b0}} + (mul_a << i);
            end else begin
                partial_products[i] <= {2*size{1'b0}};
            end
        end
        sum <= {2*size{1'b0}};
        for (i = 0; i < size; i++) begin
            sum <= sum + partial_products[i];
        end
        final_sum <= sum;
    end
end

always @(posedge clk) begin
    mul_out <= final_sum;
end

endmodule