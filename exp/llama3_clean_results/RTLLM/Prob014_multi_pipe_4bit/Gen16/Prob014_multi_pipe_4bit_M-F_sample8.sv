module multi_pipe_4bit #(
    parameter size = 4
)(
    input clk,
    input rst_n,
    input [size-1:0] mul_a,
    input [size-1:0] mul_b,
    output reg [2*size-1:0] mul_out
);

reg [size-1:0] multiplicand_reg;
reg [size-1:0] multiplier_reg;
reg [2*size-1:0] partial_sum_reg1;
reg [2*size-1:0] partial_sum_reg2;

// Input stage
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        multiplicand_reg <= {size{1'b0}};
        multiplier_reg <= {size{1'b0}};
        partial_sum_reg1 <= {2*size{1'b0}};
        partial_sum_reg2 <= {2*size{1'b0}};
        mul_out <= {2*size{1'b0}};
    end else begin
        multiplicand_reg <= mul_a;
        multiplier_reg <= mul_b;
    end
end

// Partial product generation and accumulation stage
wire [2*size-1:0] partial_sum1;
wire [2*size-1:0] partial_sum2;
assign partial_sum1 = {2*size{1'b0}};
assign partial_sum2 = {2*size{1'b0}};

reg [2*size-1:0] temp_mult;

always @(*) begin
    partial_sum1 = {2*size{1'b0}};
    partial_sum2 = {2*size{1'b0}};
    for (int i = 0; i < size; i++) begin
        if (multiplier_reg[i] == 1'b1) begin
            temp_mult = {size{1'b0}, multiplicand_reg}; // extend multiplicand with zeros
            if (i < size/2) begin
                partial_sum1 = partial_sum1 + (temp_mult << i);
            end else begin
                partial_sum2 = partial_sum2 + (temp_mult << i);
            end
        end
    end
end

// Pipeline registers
always @(posedge clk) begin
    partial_sum_reg1 <= partial_sum1;
    partial_sum_reg2 <= partial_sum2;
end

// Output stage
always @(posedge clk) begin
    mul_out <= partial_sum_reg1 + partial_sum_reg2;
end

endmodule