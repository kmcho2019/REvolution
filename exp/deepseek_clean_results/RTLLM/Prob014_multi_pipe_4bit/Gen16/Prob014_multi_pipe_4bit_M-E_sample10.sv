module multi_pipe_4bit #(
    parameter size = 4
) (
    input clk,
    input rst_n,
    input [size-1:0] mul_a,
    input [size-1:0] mul_b,
    output reg [2*size-1:0] mul_out
);

// Pipeline registers
reg [2*size-1:0] shifted_a;
reg [2*size-1:0] accumulator;
reg [size-1:0] b_reg;
reg [2:0] bit_counter;  // Counts from 0 to size-1

// Extended multiplicand
wire [2*size-1:0] ext_a = {{size{1'b0}}, mul_a};

// Pipeline Stage 1: Shift preparation and bit extraction
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        shifted_a <= '0;
        b_reg <= '0;
        bit_counter <= '0;
    end else begin
        if (bit_counter == 0) begin
            // Load new operands at start
            shifted_a <= ext_a;
            b_reg <= mul_b;
        end else begin
            // Right-shift multiplicand each cycle
            shifted_a <= shifted_a >> 1;
        end
        
        // Increment or reset bit counter
        bit_counter <= (bit_counter == size-1) ? 0 : bit_counter + 1;
    end
end

// Pipeline Stage 2: Conditional accumulation
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        accumulator <= '0;
        mul_out <= '0;
    end else begin
        if (bit_counter == 0) begin
            // Reset accumulator at start of new multiplication
            accumulator <= '0;
        end else if (b_reg[bit_counter-1]) begin
            // Add shifted multiplicand if multiplier bit is 1
            accumulator <= accumulator + (shifted_a << (bit_counter-1));
        end
        
        // Output final result when complete
        if (bit_counter == size-1) begin
            mul_out <= accumulator;
        end
    end
end

endmodule