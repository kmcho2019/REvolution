module multi_pipe_4bit #(
    parameter size = 4
) (
    input clk,
    input rst_n,
    input [size-1:0] mul_a,
    input [size-1:0] mul_b,
    output reg [2*size-1:0] mul_out
);

// Extend input signals by adding "size" number of zero bits at the most significant bit positions
wire [2*size-1:0] mul_a_ext = {size'd0, mul_a};
wire [2*size-1:0] mul_b_ext = {size'd0, mul_b};

// Generate block to perform multiplication for each bit position of the multiplier
reg [2*size-1:0] partial_product [size-1:0];
reg [2*size-1:0] reg1;
reg [2*size-1:0] reg2;

integer i;
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        // Reset condition
        for (i = 0; i < size; i++) begin
            partial_product[i] <= 'd0;
        end
        reg1 <= 'd0;
        reg2 <= 'd0;
        mul_out <= 'd0;
    end else begin
        // Multiply for each bit position of the multiplier
        for (i = 0; i < size; i++) begin
            if (mul_b_ext[i]) begin
                partial_product[i] <= mul_a_ext << i;
            end else begin
                partial_product[i] <= 'd0;
            end
        end
        
        // Add partial products using registers to store intermediate sum values
        reg1 <= partial_product[0];
        for (i = 1; i < size; i++) begin
            reg2 <= reg1 + partial_product[i];
            reg1 <= reg2;
        end
        
        // Final product calculation
        mul_out <= reg2;
    end
end

endmodule