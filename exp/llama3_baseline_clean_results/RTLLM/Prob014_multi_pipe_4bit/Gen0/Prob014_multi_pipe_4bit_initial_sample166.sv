module multi_pipe_4bit #(
    parameter size = 4
) (
    input clk,
    input rst_n,
    input [size-1:0] mul_a,
    input [size-1:0] mul_b,
    output [2*size-1:0] mul_out
);

reg [2*size-1:0] partial_product [size-1:0];
reg [2*size-1:0] reg1;
reg [2*size-1:0] reg2;
reg [2*size-1:0] sum;

integer i;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        reg1 <= 0;
        reg2 <= 0;
        mul_out <= 0;
    end else begin
        // Calculate partial products
        for (i = 0; i < size; i++) begin
            if (mul_b[i]) begin
                partial_product[i] <= {size-1{1'b0}} << i;
                partial_product[i] <= partial_product[i] | (mul_a << i);
            end else begin
                partial_product[i] <= 0;
            end
        end

        // Store intermediate sum values in registers
        reg1 <= sum;
        
        // Calculate the sum of partial products
        sum <= 0;
        for (i = 0; i < size; i++) begin
            sum <= sum + partial_product[i];
        end

        // Update product output
        reg2 <= reg1;
        mul_out <= reg2;
    end
end

endmodule