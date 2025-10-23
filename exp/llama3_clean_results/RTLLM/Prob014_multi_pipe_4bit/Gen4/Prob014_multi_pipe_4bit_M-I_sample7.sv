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
        reg1 <= 0;
        reg2 <= 0;
    end else begin
        reg1 <= partial_sum;
        reg2 <= reg1;
    end
end

// Calculate final product
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        mul_out <= 0;
    end else begin
        mul_out <= reg2;
    end
end

// Calculate partial sum
wire [2*size-1:0] partial_sum;
reg [2*size-1:0] sum;

always @(*) begin
    sum = 0;
    for (int i = 0; i < size; i++) begin
        if (mul_b[i] == 1'b1) begin
            sum = sum + (mul_a << i);
        end
    end
end

assign partial_sum = sum;

endmodule