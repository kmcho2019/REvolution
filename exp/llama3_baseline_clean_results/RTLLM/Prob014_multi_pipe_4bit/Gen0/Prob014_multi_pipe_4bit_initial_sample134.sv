module multi_pipe_4bit (
    input clk,
    input rst_n,
    input [3:0] mul_a,
    input [3:0] mul_b,
    output reg [7:0] mul_out
);

// Parameter definition
parameter size = 4;

// Internal wires and registers
reg [7:0] partial_products [size-1:0];
reg [7:0] sum_stage1;
reg [7:0] sum_stage2;

// First stage: Generate partial products
genvar i;
generate
    for (i = 0; i < size; i++) begin
        always @(*) begin
            if (mul_b[i]) begin
                partial_products[i] = {4'd0, mul_a} << i;
            end else begin
                partial_products[i] = 8'd0;
            end
        end
    end
endgenerate

// Second stage: Add partial products
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        sum_stage1 <= 8'd0;
    end else begin
        sum_stage1 <= partial_products[0] + partial_products[1] + partial_products[2] + partial_products[3];
    end
end

// Third stage: Final product calculation
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        sum_stage2 <= 8'd0;
    end else begin
        sum_stage2 <= sum_stage1;
    end
end

// Fourth stage: Final output
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        mul_out <= 8'd0;
    end else begin
        mul_out <= sum_stage2;
    end
end

endmodule