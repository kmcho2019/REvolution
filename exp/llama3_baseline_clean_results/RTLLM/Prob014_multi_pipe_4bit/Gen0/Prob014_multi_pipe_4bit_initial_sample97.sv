module multi_pipe_4bit(
    input clk,
    input rst_n,
    input [3:0] mul_a,
    input [3:0] mul_b,
    output reg [7:0] mul_out
);

localparam size = 4;

reg [7:0] partial_products [0:size-1];
reg [7:0] sum_registers [0:size-1];

integer i;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        for (i = 0; i < size; i++) begin
            partial_products[i] <= 0;
            sum_registers[i] <= 0;
        end
        mul_out <= 0;
    end else begin
        for (i = 0; i < size; i++) begin
            if (mul_b[i]) begin
                partial_products[i] <= mul_a << i;
            end else begin
                partial_products[i] <= 0;
            end
        end
        if (size == 1) begin
            sum_registers[0] <= partial_products[0];
        end else begin
            sum_registers[0] <= partial_products[0];
            for (i = 1; i < size; i++) begin
                sum_registers[i] <= sum_registers[i-1] + partial_products[i];
            end
        end
        mul_out <= sum_registers[size-1];
    end
end

endmodule