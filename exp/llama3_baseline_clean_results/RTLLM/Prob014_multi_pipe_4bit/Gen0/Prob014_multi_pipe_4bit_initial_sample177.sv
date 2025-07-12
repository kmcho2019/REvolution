module multi_pipe_4bit (
    input clk,
    input rst_n,
    input [3:0] mul_a,
    input [3:0] mul_b,
    output reg [7:0] mul_out
);

// Parameter definition
parameter size = 4;

// Intermediate signals for extended inputs
reg [7:0] mul_a_ext;
reg [7:0] mul_b_ext;

// Registers for intermediate sum values
reg [7:0] sum_reg1;
reg [7:0] sum_reg2;

// Extend input signals
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        mul_a_ext <= 8'b0;
        mul_b_ext <= 8'b0;
    end else begin
        mul_a_ext <= {4'b0, mul_a};
        mul_b_ext <= {4'b0, mul_b};
    end
end

// Generate block for multiplication
reg [7:0] partial_product [3:0];
integer i;
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        for (i = 0; i < size; i++) begin
            partial_product[i] <= 8'b0;
        end
    end else begin
        for (i = 0; i < size; i++) begin
            if (mul_b_ext[i]) begin
                partial_product[i] <= mul_a_ext << i;
            end else begin
                partial_product[i] <= 8'b0;
            end
        end
    end
end

// Update registers with sum of partial products
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        sum_reg1 <= 8'b0;
        sum_reg2 <= 8'b0;
    end else begin
        sum_reg1 <= partial_product[0] + partial_product[1];
        sum_reg2 <= partial_product[2] + partial_product[3];
    end
end

// Calculate final product
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        mul_out <= 8'b0;
    end else begin
        mul_out <= sum_reg1 + sum_reg2;
    end
end

endmodule