module multi_pipe_4bit #(parameter size = 4) (
    input clk,
    input rst_n,
    input [size-1:0] mul_a,
    input [size-1:0] mul_b,
    output reg [2*size-1:0] mul_out
);

// Pipeline registers
reg [2*size-1:0] partial_products [0:size-1];
reg [2*size-1:0] acc_reg;
reg stage_done;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Reset all registers
        for (integer i = 0; i < size; i = i + 1)
            partial_products[i] <= 0;
        acc_reg <= 0;
        mul_out <= 0;
        stage_done <= 0;
    end else begin
        if (!stage_done) begin
            // Stage 1: Generate all partial products
            for (integer i = 0; i < size; i = i + 1)
                partial_products[i] <= mul_b[i] ? (mul_a << i) : 0;
            stage_done <= 1;
        end else begin
            // Stage 2: Sum all partial products
            acc_reg <= partial_products[0] + partial_products[1] + 
                      partial_products[2] + partial_products[3];
            mul_out <= acc_reg;
            stage_done <= 0;  // Ready for next operation
        end
    end
end

endmodule