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

// Stage 1: Shift and add partial products
wire [2*size-1:0] partial_sum;
generate
    for (genvar i = 0; i < size; i++) begin
        wire [2*size-1:0] shifted_a;
        assign shifted_a = (mul_a << i);
        if (i == 0) begin
            assign partial_sum = (mul_b[i] == 1'b1) ? shifted_a : 'd0;
        end else begin
            wire [2*size-1:0] prev_sum;
            assign prev_sum = (i == 1) ? partial_sum : prev_sum;
            assign partial_sum = (mul_b[i] == 1'b1) ? prev_sum + shifted_a : prev_sum;
        end
    end
endgenerate

// Stage 2: Store intermediate sum in reg1
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        reg1 <= 'd0;
    end else begin
        reg1 <= partial_sum;
    end
end

// Stage 3: Store final sum in reg2 and output
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        reg2 <= 'd0;
        mul_out <= 'd0;
    end else begin
        reg2 <= reg1;
        mul_out <= reg2;
    end
end

endmodule