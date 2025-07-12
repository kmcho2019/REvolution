module multi_pipe_4bit (
    input clk,
    input rst_n,
    input [3:0] mul_a,
    input [3:0] mul_b,
    output [7:0] mul_out
);

parameter size = 4;

reg [7:0] reg1;
reg [7:0] reg2;
reg [7:0] partial_products [3:0];

integer i;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        reg1 <= 0;
        reg2 <= 0;
        mul_out <= 0;
    end else begin
        // Generate partial products
        for (i = 0; i < size; i++) begin
            if (mul_b[i]) begin
                partial_products[i] <= mul_a << i;
            end else begin
                partial_products[i] <= 0;
            end
        end
        
        // Store intermediate sum values in registers
        reg1 <= partial_products[0];
        for (i = 1; i < size; i++) begin
            reg2 <= reg1 + partial_products[i];
            reg1 <= reg2;
        end
        
        // Calculate final product
        mul_out <= reg2;
    end
end

endmodule