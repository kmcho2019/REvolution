module multi_pipe_4bit (
    input clk,
    input rst_n,
    input [3:0] mul_a,
    input [3:0] mul_b,
    output reg [7:0] mul_out
);

parameter size = 4;

// Extended multiplicand
reg [7:0] ext_a;
// Shift register for multiplier
reg [3:0] b_shift;
// Pipeline registers
reg [7:0] accumulator;
reg [2:0] cycle_count;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Reset all registers
        ext_a <= 8'd0;
        b_shift <= 4'd0;
        accumulator <= 8'd0;
        mul_out <= 8'd0;
        cycle_count <= 3'd0;
    end else begin
        if (cycle_count == 0) begin
            // Initialize on first cycle
            ext_a <= {4'b0, mul_a};
            b_shift <= mul_b;
            accumulator <= 8'd0;
            cycle_count <= cycle_count + 1;
        end else if (cycle_count <= size) begin
            // Pipeline Stage 1: Shift and conditional add
            if (b_shift[0]) begin
                accumulator <= accumulator + ext_a;
            end
            
            // Pipeline Stage 2: Shift operations
            ext_a <= ext_a << 1;
            b_shift <= b_shift >> 1;
            
            cycle_count <= cycle_count + 1;
            
            // Final result ready after 4 cycles
            if (cycle_count == size) begin
                mul_out <= accumulator;
                cycle_count <= 3'd0;
            end
        end
    end
end

endmodule