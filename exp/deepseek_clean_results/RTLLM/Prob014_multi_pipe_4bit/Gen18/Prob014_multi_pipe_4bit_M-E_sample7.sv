module multi_pipe_4bit #(
    parameter size = 4
) (
    input clk,
    input rst_n,
    input [size-1:0] mul_a,
    input [size-1:0] mul_b,
    output reg [2*size-1:0] mul_out
);

reg [2*size-1:0] accumulator;
reg [size-1:0] multiplicand;
reg [size-1:0] multiplier;
reg [2:0] cycle_count;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        accumulator <= 0;
        multiplicand <= 0;
        multiplier <= 0;
        cycle_count <= 0;
        mul_out <= 0;
    end else begin
        if (cycle_count == 0) begin
            // Initialization cycle
            multiplicand <= mul_a;
            multiplier <= mul_b;
            accumulator <= 0;
            cycle_count <= cycle_count + 1;
        end else if (cycle_count <= size) begin
            // Processing cycles
            if (multiplier[0]) begin
                accumulator <= accumulator + multiplicand;
            end
            multiplier <= multiplier >> 1;
            multiplicand <= multiplicand << 1;
            cycle_count <= cycle_count + 1;
            
            // Final result capture
            if (cycle_count == size) begin
                mul_out <= accumulator;
            end
        end else begin
            // Idle state
            cycle_count <= 0;
        end
    end
end

endmodule