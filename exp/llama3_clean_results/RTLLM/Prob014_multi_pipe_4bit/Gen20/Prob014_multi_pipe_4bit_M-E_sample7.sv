module multi_pipe_4bit (
    input clk,  // clock signal
    input rst_n,  // active-low reset signal
    input [3:0] mul_a,  // input signal representing the multiplicand
    input [3:0] mul_b,  // input signal representing the multiplier
    output reg [7:0] mul_out  // product output signal
);

parameter size = 4;

// Stage 1: Partial product generation
reg [7:0] partial_product [0:size-1];

// Stage 2: Accumulation
reg [7:0] accumulated_product;

// Stage 3: Final product calculation
reg [7:0] final_product;

// Generate partial products
genvar i;
generate
    for (i = 0; i < size; i++) begin
        always @(posedge clk or negedge rst_n) begin
            if (!rst_n) begin
                partial_product[i] <= 8'd0;
            end else begin
                if (mul_b[i]) begin
                    partial_product[i] <= {4'b0, mul_a} << i;
                end else begin
                    partial_product[i] <= 8'd0;
                end
            end
        end
    end
endgenerate

// Accumulate partial products
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        accumulated_product <= 8'd0;
    end else begin
        accumulated_product <= partial_product[0] + partial_product[1] + partial_product[2] + partial_product[3];
    end
end

// Calculate final product
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        final_product <= 8'd0;
    end else begin
        final_product <= accumulated_product;
    end
end

// Output final product
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        mul_out <= 8'd0;
    end else begin
        mul_out <= final_product;
    end
end

endmodule