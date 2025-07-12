module multi_pipe_4bit (
    input clk,
    input rst_n,
    input [3:0] mul_a,
    input [3:0] mul_b,
    output reg [7:0] mul_out
);

parameter size = 4;
reg [1:0] bit_counter;
reg [7:0] extended_a;
reg [7:0] sum, carry;
reg [3:0] b_reg;

// Bit-serial processing control
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        bit_counter <= 0;
        b_reg <= 0;
        extended_a <= 0;
        sum <= 0;
        carry <= 0;
        mul_out <= 0;
    end else begin
        if (bit_counter == 0) begin
            // Initialize on first cycle
            b_reg <= mul_b;
            extended_a <= {4'b0, mul_a};
            sum <= 0;
            carry <= 0;
            bit_counter <= bit_counter + 1;
        end else if (bit_counter <= size) begin
            // Process each bit
            if (b_reg[0]) begin
                {carry, sum} <= sum + (extended_a << (bit_counter-1)) + carry;
            end
            b_reg <= b_reg >> 1;
            bit_counter <= bit_counter + 1;
            
            // Final result when done
            if (bit_counter == size) begin
                mul_out <= sum + carry;
                bit_counter <= 0;
            end
        end
    end
end

endmodule