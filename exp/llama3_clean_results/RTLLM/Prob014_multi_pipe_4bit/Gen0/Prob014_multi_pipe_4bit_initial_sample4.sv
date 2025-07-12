module multi_pipe_4bit #(
    parameter size = 4
) (
    input  clk,
    input  rst_n,
    input  [size-1:0] mul_a,
    input  [size-1:0] mul_b,
    output [2*size-1:0] mul_out
);

// Stage 1: Multiplication and partial product generation
reg [2*size-1:0] partial_product [size];
reg [2*size-1:0] sum;
reg [2*size-1:0] final_product;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        for (int i = 0; i < size; i++) begin
            partial_product[i] <= {size{1'b0}};
        end
        sum <= {size{1'b0}};
        final_product <= {size{1'b0}};
    end else begin
        for (int i = 0; i < size; i++) begin
            if (mul_b[i]) begin
                partial_product[i] <= {size{1'b0}} << i;
            end else begin
                partial_product[i] <= {size{1'b0}};
            end
        end
        sum <= {size{1'b0}};
        for (int i = 0; i < size; i++) begin
            if (mul_b[i]) begin
                sum <= sum + (mul_a << i);
            end
        end
    end
end

// Stage 2: Final product calculation
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        final_product <= {size{1'b0}};
    end else begin
        final_product <= sum;
    end
end

// Output assignment
assign mul_out = final_product;

endmodule