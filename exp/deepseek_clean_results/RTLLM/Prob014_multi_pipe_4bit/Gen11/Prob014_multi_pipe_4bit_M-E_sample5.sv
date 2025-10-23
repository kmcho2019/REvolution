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

// Extended multiplicand wires
wire [2*size-1:0] ext_a = { {size{1'b0}}, mul_a };

// Pipeline stage 1: Process bits 0 and 1
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        accum_stage1 <= 0;
    end else begin
        case (mul_b[1:0])
            2'b00: accum_stage1 <= 0;
            2'b01: accum_stage1 <= ext_a;
            2'b10: accum_stage1 <= ext_a << 1;
            2'b11: accum_stage1 <= (ext_a << 1) + ext_a;
        endcase
    end
end

// Pipeline stage 2: Process bits 2 and 3 and accumulate
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        accum_stage2 <= 0;
        mul_out <= 0;
    end else begin
        case (mul_b[3:2])
            2'b00: accum_stage2 <= accum_stage1;
            2'b01: accum_stage2 <= accum_stage1 + (ext_a << 2);
            2'b10: accum_stage2 <= accum_stage1 + (ext_a << 3);
            2'b11: accum_stage2 <= accum_stage1 + (ext_a << 3) + (ext_a << 2);
        endcase
        mul_out <= accum_stage2;
    end
end

endmodule