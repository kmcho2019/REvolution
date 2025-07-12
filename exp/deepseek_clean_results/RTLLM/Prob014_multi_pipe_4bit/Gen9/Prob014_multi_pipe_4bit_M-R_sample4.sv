module multi_pipe_4bit (
    input clk,
    input rst_n,
    input [3:0] mul_a,
    input [3:0] mul_b,
    output reg [7:0] mul_out
);

parameter size = 4;

// Combinational partial products generation
wire [7:0] pp [0:3];
assign pp[0] = mul_b[0] ? {4'b0, mul_a}       : 8'b0;
assign pp[1] = mul_b[1] ? {3'b0, mul_a, 1'b0} : 8'b0;
assign pp[2] = mul_b[2] ? {2'b0, mul_a, 2'b0} : 8'b0;
assign pp[3] = mul_b[3] ? {1'b0, mul_a, 3'b0} : 8'b0;

// Pipeline Stage 1: Partial Product Registers (single array)
reg [7:0] pp_reg [0:3];

generate
    genvar i;
    for (i = 0; i < 4; i = i + 1) begin : pp_reg_gen
        always @(posedge clk or negedge rst_n) begin
            if (!rst_n) begin
                pp_reg[i] <= 8'b0;
            end else begin
                pp_reg[i] <= pp[i];
            end
        end
    end
endgenerate

// Pipeline Stage 2: Intermediate Sum and Output
wire [7:0] sum_intermediate = pp_reg[0] + pp_reg[1];
wire [7:0] sum_final = sum_intermediate + pp_reg[2] + pp_reg[3];

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        mul_out <= 8'b0;
    end else begin
        mul_out <= sum_final;
    end
end

endmodule