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
        reg1 <= partial_sum;
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

// Calculate partial sum using a generate block
wire [2*size-1:0] partial_sum;
reg [2*size-1:0] temp_sum;
always @(*) begin
    temp_sum = {2*size{1'b0}};
    for (int i = 0; i < size; i++) begin
        if (mul_b[i] == 1'b1) begin
            temp_sum = temp_sum + ({size{1'b0}}, mul_a) << i;
        end
    end
    partial_sum = temp_sum;
end

endmodule