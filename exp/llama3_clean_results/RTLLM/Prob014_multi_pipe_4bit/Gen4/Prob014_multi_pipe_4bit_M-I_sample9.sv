module multi_pipe_4bit #(
    parameter size = 4
)(
    input clk,
    input rst_n,
    input [size-1:0] mul_a,
    input [size-1:0] mul_b,
    output reg [2*size-1:0] mul_out
);

reg [2*size-1:0] reg1;
reg [2*size-1:0] reg2;

// Initialize registers
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        reg1 <= {2*size{1'b0}};
        reg2 <= {2*size{1'b0}};
    end else begin
        reg1 <= calculate_partial_sum(mul_a, mul_b);
        reg2 <= reg1;
    end
end

// Calculate final product
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        mul_out <= {2*size{1'b0}};
    end else begin
        mul_out <= reg2;
    end
end

// Function to calculate partial sum
function [2*size-1:0] calculate_partial_sum(input [size-1:0] mul_a, input [size-1:0] mul_b);
    reg [2*size-1:0] partial_sum;
    integer i;
    begin
        partial_sum = {2*size{1'b0}};
        for (i = 0; i < size; i = i + 1) begin
            if (mul_b[i]) begin
                partial_sum = partial_sum + (mul_a << i);
            end
        end
        calculate_partial_sum = partial_sum;
    end
endfunction

endmodule