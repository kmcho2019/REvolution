module multi_pipe_4bit #(parameter size = 4) (
    input clk,
    input rst_n,
    input [size-1:0] mul_a,
    input [size-1:0] mul_b,
    output reg [2*size-1:0] mul_out
);

// Pipeline registers
reg [2*size-1:0] acc_reg;
reg [size-1:0] a_reg;
reg [size-1:0] b_reg;
reg [2*size-1:0] shifted_a;
reg [1:0] bit_counter;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Reset all registers
        a_reg <= 0;
        b_reg <= 0;
        acc_reg <= 0;
        shifted_a <= 0;
        bit_counter <= 0;
        mul_out <= 0;
    end else begin
        if (bit_counter == 0) begin
            // Stage 1: Initialize operation
            a_reg <= mul_a;
            b_reg <= mul_b;
            shifted_a <= { {size{1'b0}}, mul_a };
            acc_reg <= 0;
            bit_counter <= bit_counter + 1;
        end
        else if (bit_counter < size) begin
            // Stage 2: Process current bit
            if (b_reg[bit_counter-1])
                acc_reg <= acc_reg + shifted_a;
            
            // Prepare for next bit
            shifted_a <= shifted_a << 1;
            bit_counter <= bit_counter + 1;
            
            // Output result when processing last bit
            if (bit_counter == size-1)
                mul_out <= acc_reg + (b_reg[bit_counter] ? shifted_a : 0);
        end
        else begin
            // Reset for next operation
            bit_counter <= 0;
        end
    end
end

endmodule