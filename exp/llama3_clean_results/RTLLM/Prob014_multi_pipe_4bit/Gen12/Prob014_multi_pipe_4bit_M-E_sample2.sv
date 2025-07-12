module multi_pipe_4bit #(
    parameter size = 4
)(
    input clk,
    input rst_n,
    input [size-1:0] mul_a,
    input [size-1:0] mul_b,
    output reg [2*size-1:0] mul_out
);

reg [size-1:0] multiplicand_reg;
reg [size-1:0] multiplier_reg;
reg [2*size-1:0] partial_product [size-1:0];
reg [2*size-1:0] accumulated_sum_reg1;
reg [2*size-1:0] accumulated_sum_reg2;
reg [2*size-1:0] accumulated_sum_reg3;
reg [2*size-1:0] final_product_reg;

// Input stage
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        multiplicand_reg <= {size{1'b0}};
        multiplier_reg <= {size{1'b0}};
    end else begin
        multiplicand_reg <= mul_a;
        multiplier_reg <= mul_b;
    end
end

// Partial product generation stage
always @(*) begin
    for (int i = 0; i < size; i++) begin
        if (multiplier_reg[i] == 1'b1) begin
            partial_product[i] = {size{1'b0}, multiplicand_reg} << i;
        end else begin
            partial_product[i] = {2*size{1'b0}};
        end
    end
end

// Accumulation stage
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        accumulated_sum_reg1 <= {2*size{1'b0}};
        accumulated_sum_reg2 <= {2*size{1'b0}};
        accumulated_sum_reg3 <= {2*size{1'b0}};
    end else begin
        accumulated_sum_reg1 <= partial_product[0] + partial_product[1];
        accumulated_sum_reg2 <= partial_product[2] + partial_product[3];
        accumulated_sum_reg3 <= accumulated_sum_reg1 + accumulated_sum_reg2;
    end
end

// Output stage
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        final_product_reg <= {2*size{1'b0}};
    end else begin
        final_product_reg <= accumulated_sum_reg3;
    end
end

// Output assignment
always @(*) begin
    mul_out = final_product_reg;
end

endmodule