module multi_pipe_4bit #(
    parameter size = 4
) (
    input  clk,
    input  rst_n,
    input  [size-1:0] mul_a,
    input  [size-1:0] mul_b,
    output [2*size-1:0] mul_out
);

// Stage 1: Partial product generation
reg [2*size-1:0] partial_product [size];
reg [2*size-1:0] sum;

// Initialize partial products and sum to zero on reset
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        for (int i = 0; i < size; i++) begin
            partial_product[i] <= {size{1'b0}};
        end
        sum <= {2*size{1'b0}};
    end else begin
        for (int i = 0; i < size; i++) begin
            if (mul_b[i]) begin
                partial_product[i] <= {size{1'b0}} | (mul_a << i);
            end else begin
                partial_product[i] <= {2*size{1'b0}};
            end
        end
    end
end

// Stage 2: Summation of partial products
reg [2*size-1:0] sum_reg;
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        sum_reg <= {2*size{1'b0}};
    end else begin
        sum_reg <= sum;
        sum <= {2*size{1'b0}};
        for (int i = 0; i < size; i++) begin
            sum <= sum + partial_product[i];
        end
    end
end

// Output assignment
assign mul_out = sum_reg;

endmodule