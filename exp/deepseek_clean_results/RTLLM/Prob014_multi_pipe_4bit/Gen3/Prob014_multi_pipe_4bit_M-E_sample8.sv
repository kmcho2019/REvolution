module multi_pipe_4bit #(parameter size = 4) (
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
    reg [2:0] bit_counter;
    
    // Control signals
    wire done = (bit_counter == size);
    wire init = (bit_counter == 0);

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset all registers
            shifted_a <= 0;
            accumulator <= 0;
            b_reg <= 0;
            bit_counter <= 0;
            mul_out <= 0;
        end else begin
            if (init) begin
                // Initialize pipeline
                shifted_a <= {{size{1'b0}}, mul_a};
                accumulator <= 0;
                b_reg <= mul_b;
                bit_counter <= 1;
            end else if (!done) begin
                // Pipeline Stage 1: Shift multiplicand
                shifted_a <= shifted_a << 1;
                
                // Pipeline Stage 2: Conditional accumulate
                if (b_reg[0])
                    accumulator <= accumulator + shifted_a;
                
                // Update control registers
                b_reg <= b_reg >> 1;
                bit_counter <= bit_counter + 1;
                
                // Capture final result
                if (bit_counter == size-1)
                    mul_out <= accumulator + (b_reg[0] ? shifted_a : 0);
            end
        end
    end

endmodule