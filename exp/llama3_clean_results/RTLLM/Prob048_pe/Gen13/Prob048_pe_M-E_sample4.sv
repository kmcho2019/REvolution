module pe (
    input clk,  // Clock signal
    input rst,  // Reset signal
    input [31:0] a,  // Input operand A
    input [31:0] b,  // Input operand B
    output [31:0] c  // Accumulated result
);

reg [31:0] c_reg;
wire [31:0] parallel_mult_result;
wire [31:0] sequential_mult_result;
reg [3:0] state;

// Parallel multiplier for MSBs
assign parallel_mult_result = a[31:16] * b[31:16];

// Sequential multiplier for LSBs
reg [15:0] a_lsb;
reg [15:0] b_lsb;
reg [31:0] sequential_mult_reg;
always @(posedge clk) begin
    if (rst) begin
        sequential_mult_reg <= 32'd0;
        a_lsb <= a[15:0];
        b_lsb <= b[15:0];
        state <= 4'd0;
    end else begin
        case (state)
            4'd0: begin
                sequential_mult_reg <= a_lsb * b_lsb;
                state <= 4'd1;
            end
            4'd1: begin
                state <= 4'd2;
            end
            4'd2: begin
                state <= 4'd3;
            end
            4'd3: begin
                state <= 4'd0;
            end
            default: state <= 4'd0;
        endcase
    end
end
assign sequential_mult_result = sequential_mult_reg;

// Accumulation operation
always @(posedge clk) begin
    if (rst) begin
        c_reg <= 32'd0;
    end else begin
        c_reg <= c_reg + parallel_mult_result + sequential_mult_result;
    end
end

// Assign c_reg to output c
assign c = c_reg;

endmodule