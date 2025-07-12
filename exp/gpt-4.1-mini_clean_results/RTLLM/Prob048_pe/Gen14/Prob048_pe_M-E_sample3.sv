module pe (
    input  wire        clk,
    input  wire        rst,      // synchronous active-high reset
    input  wire [31:0] a,
    input  wire [31:0] b,
    output wire [31:0] c
);

    // Pipeline register for multiplier output (64-bit)
    reg [63:0] mult_pipe;

    // 64-bit accumulator register
    reg [63:0] acc;

    // Stage 1: Register multiplication result
    always @(posedge clk) begin
        if (rst) begin
            mult_pipe <= 64'd0;
        end else begin
            mult_pipe <= a * b;
        end
    end

    // Stage 2: Accumulate registered multiplication result
    always @(posedge clk) begin
        if (rst) begin
            acc <= 64'd0;
        end else begin
            acc <= acc + mult_pipe;
        end
    end

    // Output lower 32 bits of the accumulator
    assign c = acc[31:0];

endmodule