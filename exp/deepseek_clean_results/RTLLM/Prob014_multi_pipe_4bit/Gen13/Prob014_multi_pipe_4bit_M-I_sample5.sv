module multi_pipe_4bit #(
    parameter size = 4
) (
    input clk,
    input rst_n,
    input [size-1:0] mul_a,
    input [size-1:0] mul_b,
    output reg [2*size-1:0] mul_out
);

// Stage 1: Partial Product Generation and First Level Addition
reg [2*size-1:0] pp [0:size-1];
reg [2*size-1:0] sum01, sum23;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        for (integer i = 0; i < size; i = i + 1) begin
            pp[i] <= '0;
        end
        sum01 <= '0;
        sum23 <= '0;
    end else begin
        // Generate partial products with proper shifts
        for (integer i = 0; i < size; i = i + 1) begin
            pp[i] <= mul_b[i] ? (mul_a << i) : '0;
        end
        
        // First level of addition (balanced tree)
        sum01 <= pp[0] + pp[1];
        sum23 <= pp[2] + pp[3];
    end
end

// Stage 2: Final Summation
reg [2*size-1:0] final_sum;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        final_sum <= '0;
    end else begin
        final_sum <= sum01 + sum23;
    end
end

// Stage 3: Output Register
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        mul_out <= '0;
    end else begin
        mul_out <= final_sum;
    end
end

endmodule