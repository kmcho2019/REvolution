module multi_pipe_4bit #(
    parameter size = 4
)(
    input clk,
    input rst_n,
    input [size-1:0] mul_a,
    input [size-1:0] mul_b,
    output reg [2*size-1:0] mul_out
);

reg [size-1:0] reg_a;
reg [size-1:0] reg_b;
reg [2*size-1:0] reg_pp [size];
reg [2*size-1:0] reg_sum1;
reg [2*size-1:0] reg_sum2;

// Combinatorial logic to calculate partial products
assign reg_pp[0] = (mul_b[0] == 1'b1) ? { {size{1'b0}}, mul_a } : {2*size{1'b0}};
assign reg_pp[1] = (mul_b[1] == 1'b1) ? { {size-1{1'b0}}, mul_a, 1'b0 } : {2*size{1'b0}};
assign reg_pp[2] = (mul_b[2] == 1'b1) ? { {size-2{1'b0}}, mul_a, 2'b00 } : {2*size{1'b0}};
assign reg_pp[3] = (mul_b[3] == 1'b1) ? { {size-3{1'b0}}, mul_a, 3'b000 } : {2*size{1'b0}};

// Sequential logic to store intermediate results and propagate them through the pipeline
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        reg_a <= {size{1'b0}};
        reg_b <= {size{1'b0}};
        reg_sum1 <= {2*size{1'b0}};
        reg_sum2 <= {2*size{1'b0}};
        mul_out <= {2*size{1'b0}};
    end else begin
        reg_a <= mul_a;
        reg_b <= mul_b;
        reg_sum1 <= reg_pp[0] + reg_pp[1];
        reg_sum2 <= reg_sum1 + reg_pp[2] + reg_pp[3];
        mul_out <= reg_sum2;
    end
end

endmodule