module multi_pipe_4bit (
    input clk,  // clock signal
    input rst_n,  // active-low reset signal
    input [3:0] mul_a,  // input signal representing the multiplicand
    input [3:0] mul_b,  // input signal representing the multiplier
    output reg [7:0] mul_out  // product output signal
);

parameter size = 4;

// Pipeline registers
reg [7:0] product_reg;
reg [7:0] output_reg;

// Bit-level multiplication and addition logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        product_reg <= 8'd0;
        output_reg <= 8'd0;
    end else begin
        if (mul_b[0] == 1'b1) begin
            product_reg <= mul_a;
        end else begin
            product_reg <= 8'd0;
        end
        for (int i = 1; i < size; i++) begin
            if (mul_b[i] == 1'b1) begin
                product_reg <= product_reg + (mul_a << i);
            end
        end
        output_reg <= product_reg;
    end
end

// Assign output
always @(posedge clk) begin
    mul_out <= output_reg;
end

endmodule