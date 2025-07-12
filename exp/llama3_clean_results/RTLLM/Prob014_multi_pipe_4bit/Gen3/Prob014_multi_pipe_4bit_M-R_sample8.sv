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

// Calculate partial sum using a combinational logic
wire [2*size-1:0] partial_sum;
assign partial_sum = (
    (mul_b[0] == 1'b1) ? ({size{1'b0}}, mul_a) : {2*size{1'b0}} +
    (mul_b[1] == 1'b1) ? ({size{1'b0}}, mul_a) << 1 : {2*size{1'b0}} +
    (mul_b[2] == 1'b1) ? ({size{1'b0}}, mul_a) << 2 : {2*size{1'b0}} +
    (mul_b[3] == 1'b1) ? ({size{1'b0}}, mul_a) << 3 : {2*size{1'b0}}
);

endmodule