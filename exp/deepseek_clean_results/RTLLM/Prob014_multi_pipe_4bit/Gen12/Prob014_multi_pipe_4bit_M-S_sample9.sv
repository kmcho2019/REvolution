module multi_pipe_4bit #(parameter size = 4) (
    input clk,
    input rst_n,
    input [size-1:0] mul_a,
    input [size-1:0] mul_b,
    output reg [2*size-1:0] mul_out
);

// Pipeline registers
reg [2*size-1:0] accum_stage1;
reg [2*size-1:0] accum_stage2;

// Extended and shifted multiplicands
wire [2*size-1:0] ext_a = { {size{1'b0}}, mul_a };
wire [2*size-1:0] ext_a_1 = ext_a << 1;
wire [2*size-1:0] ext_a_2 = ext_a << 2;
wire [2*size-1:0] ext_a_3 = ext_a << 3;

// Pipeline stage 1: Process bits 0 and 1
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        accum_stage1 <= 0;
    end else begin
        accum_stage1 <= (mul_b[0] ? ext_a : 0) + 
                       (mul_b[1] ? ext_a_1 : 0);
    end
end

// Pipeline stage 2: Process bits 2 and 3 and accumulate
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        accum_stage2 <= 0;
        mul_out <= 0;
    end else begin
        accum_stage2 <= accum_stage1 + 
                       (mul_b[2] ? ext_a_2 : 0) + 
                       (mul_b[3] ? ext_a_3 : 0);
        mul_out <= accum_stage2;
    end
end

endmodule