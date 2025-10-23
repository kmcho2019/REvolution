module pe (
    input wire clk,
    input wire rst,
    input wire [31:0] a,
    input wire [31:0] b,
    output wire [31:0] c
);

    // Pipeline register for multiplier output (64-bit)
    reg [63:0] mult_pipe;

    // 64-bit accumulator split into high and low 32-bit parts
    reg [31:0] accum_low;
    reg [31:0] accum_high;

    // Wires for addition with carry
    wire [31:0] sum_low;
    wire carry_out;
    wire [31:0] sum_high;

    // Add lower 32 bits with multiplier lower part
    assign {carry_out, sum_low} = accum_low + mult_pipe[31:0];
    // Add higher 32 bits with multiplier higher part plus carry
    assign sum_high = accum_high + mult_pipe[63:32] + carry_out;

    always @(posedge clk) begin
        if (rst) begin
            mult_pipe <= 64'd0;
            accum_low <= 32'd0;
            accum_high <= 32'd0;
        end else begin
            // Pipeline multiplier output
            mult_pipe <= a * b;
            // Accumulate on pipelined multiplier result from previous cycle
            accum_low <= sum_low;
            accum_high <= sum_high;
        end
    end

    // Output lower 32 bits of accumulator
    assign c = accum_low;

endmodule