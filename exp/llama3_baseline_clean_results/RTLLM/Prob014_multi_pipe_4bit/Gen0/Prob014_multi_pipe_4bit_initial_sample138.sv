module multi_pipe_4bit(
    input clk,
    input rst_n,
    input [3:0] mul_a,
    input [3:0] mul_b,
    output [7:0] mul_out
);

// Parameters
parameter size = 4;

// Intermediate signals
reg [7:0] partial_product [size];
reg [7:0] intermediate_sum [size-1:0];
reg [7:0] reg1;
reg [7:0] reg2;
reg [7:0] sum;

// Generate block for partial product generation
genvar i;
generate
    for (i = 0; i < size; i = i + 1) begin
        if (mul_b[i]) begin
            assign partial_product[i] = {4'b0, mul_a} << i;
        end else begin
            assign partial_product[i] = 8'd0;
        end
    end
endgenerate

// Register for storing intermediate sum values
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        reg1 <= 8'd0;
        reg2 <= 8'd0;
        sum <= 8'd0;
    end else begin
        reg1 <= partial_product[0];
        reg2 <= reg1 + partial_product[1];
        sum <= reg2 + partial_product[2] + partial_product[3];
    end
end

// Final product calculation
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        mul_out <= 8'd0;
    end else begin
        mul_out <= sum;
    end
end

endmodule