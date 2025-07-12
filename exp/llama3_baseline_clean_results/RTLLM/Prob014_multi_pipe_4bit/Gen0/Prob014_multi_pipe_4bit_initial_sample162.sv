module multi_pipe_4bit #(
    parameter size = 4
)(
    input clk,
    input rst_n,
    input [size-1:0] mul_a,
    input [size-1:0] mul_b,
    output [2*size-1:0] mul_out
);

reg [2*size-1:0] partial_products [size-1:0];
reg [2*size-1:0] reg1;
reg [2*size-1:0] reg2;

integer i;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        for (i = 0; i < size; i++) begin
            partial_products[i] <= 0;
        end
        reg1 <= 0;
        reg2 <= 0;
        mul_out <= 0;
    end else begin
        for (i = 0; i < size; i++) begin
            if (mul_b[i]) begin
                partial_products[i] <= {size{i}}mul_a;
            end else begin
                partial_products[i] <= 0;
            end
        end
        reg1 <= partial_products[0];
        for (i = 1; i < size; i++) begin
            reg1 <= reg1 + partial_products[i];
        end
        reg2 <= reg1;
        mul_out <= reg2;
    end
end

endmodule