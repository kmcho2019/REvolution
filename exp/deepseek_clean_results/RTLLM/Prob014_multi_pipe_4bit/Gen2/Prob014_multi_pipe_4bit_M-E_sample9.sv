module multi_pipe_4bit #(parameter size = 4) (
    input clk,
    input rst_n,
    input [size-1:0] mul_a,
    input [size-1:0] mul_b,
    output reg [2*size-1:0] mul_out
);

    // Extended multiplicand with zero padding
    wire [2*size-1:0] ext_a = {{size{1'b0}}, mul_a};

    // Shift register for multiplier bits (LSB first)
    reg [size-1:0] b_shift;
    // Accumulator register
    reg [2*size-1:0] accumulator;
    // Cycle counter
    reg [1:0] cycle;

    // Combinational partial product
    wire [2*size-1:0] partial_product = b_shift[0] ? ext_a : 0;
    wire [2*size-1:0] next_accum = accumulator + (partial_product << cycle);

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset all registers
            b_shift <= 0;
            accumulator <= 0;
            cycle <= 0;
            mul_out <= 0;
        end else begin
            if (cycle == 0) begin
                // First cycle - load new operands
                b_shift <= mul_b;
                accumulator <= 0;
                cycle <= cycle + 1;
            end else if (cycle < size) begin
                // Processing cycles
                b_shift <= b_shift >> 1;
                accumulator <= next_accum;
                cycle <= cycle + 1;
            end else begin
                // Final cycle - output result
                mul_out <= next_accum;
                cycle <= 0;
            end
        end
    end

endmodule