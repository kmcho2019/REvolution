module pe (
    input clk,  // Clock signal
    input rst,  // Reset signal
    input [31:0] a,  // Input operand A
    input [31:0] b,  // Input operand B
    output [31:0] c  // Accumulated result
);

reg [31:0] a_reg, b_reg;
reg [31:0] mult_result;
reg [31:0] accum_result;
reg [31:0] pipe_reg1, pipe_reg2;

// Stage 1: Register inputs
always @(posedge clk or posedge rst) begin
    if (rst) begin
        a_reg <= 32'd0;
        b_reg <= 32'd0;
    end else begin
        a_reg <= a;
        b_reg <= b;
    end
end

// Stage 2: Shift-Add Multiplier
always @(posedge clk or posedge rst) begin
    if (rst) begin
        mult_result <= 32'd0;
    end else begin
        mult_result <= 32'd0;  // Initialize for new cycle
        for (int i = 0; i < 32; i++) begin
            if (b_reg[i]) begin
                mult_result <= mult_result + (a_reg << i);
            end
        end
    end
end

// Stage 3: Pipelined Accumulator
always @(posedge clk or posedge rst) begin
    if (rst) begin
        pipe_reg1 <= 32'd0;
    end else begin
        pipe_reg1 <= mult_result;
    end
end

always @(posedge clk or posedge rst) begin
    if (rst) begin
        pipe_reg2 <= 32'd0;
    end else begin
        pipe_reg2 <= pipe_reg1;
    end
end

always @(posedge clk or posedge rst) begin
    if (rst) begin
        accum_result <= 32'd0;
    end else begin
        accum_result <= pipe_reg2 + accum_result;
    end
end

// Output
assign c = accum_result;

endmodule