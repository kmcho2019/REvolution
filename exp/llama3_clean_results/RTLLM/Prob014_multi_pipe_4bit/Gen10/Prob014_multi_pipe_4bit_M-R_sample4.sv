module multi_pipe_4bit #(
    parameter size = 4
)(
    input clk,
    input rst_n,
    input [size-1:0] mul_a,
    input [size-1:0] mul_b,
    output reg [2*size-1:0] mul_out
);

reg [2*size-1:0] partial_product_reg;
reg [2*size-1:0] accumulated_sum_reg;
reg [size-1:0] counter;

// State machine
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        counter <= {size{1'b0}};
    end else begin
        if (counter == size-1) begin
            counter <= 0;
        end else begin
            counter <= counter + 1'b1;
        end
    end
end

// Partial product generation stage
always @(posedge clk) begin
    if (counter == 0) begin
        partial_product_reg <= {size{1'b0}, mul_a};
    end else if (mul_b[counter-1] == 1'b1) begin
        partial_product_reg <= {size{1'b0}, mul_a} << counter;
    end else begin
        partial_product_reg <= {2*size{1'b0}};
    end
end

// Accumulation stage
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        accumulated_sum_reg <= {2*size{1'b0}};
    end else begin
        accumulated_sum_reg <= accumulated_sum_reg + partial_product_reg;
    end
end

// Output stage
always @(posedge clk) begin
    if (counter == 0) begin
        mul_out <= accumulated_sum_reg;
    end
end

endmodule