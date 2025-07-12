module multi_pipe_4bit #(
    parameter size = 4
)(
    input clk,
    input rst_n,
    input [size-1:0] mul_a,
    input [size-1:0] mul_b,
    output reg [2*size-1:0] mul_out
);

reg [2*size-1:0] multiplicand;
reg [2*size-1:0] accumulator;
reg [size-1:0] multiplier;

integer i;

// Initialize registers
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        multiplicand <= {size{1'b0}, mul_a};
        accumulator <= {2*size{1'b0}};
        multiplier <= mul_b;
    end else begin
        // Check most significant bit of multiplier
        if (multiplier[size-1] == 1'b1) begin
            accumulator <= accumulator + multiplicand;
        end
        
        // Shift multiplicand left by one position
        multiplicand <= {multiplicand[2*size-2:0], 1'b0};
        
        // Shift multiplier left by one position
        multiplier <= {multiplier[size-2:0], 1'b0};
    end
end

// Update output after all bits of multiplier have been processed
always @(posedge clk) begin
    if (multiplier == {size{1'b0}}) begin
        mul_out <= accumulator;
    end
end

endmodule