module pe (
    input  wire        clk,
    input  wire        rst,    // synchronous active-high reset
    input  wire [31:0] a,
    input  wire [31:0] b,
    output wire [31:0] c
);

    // Registers to pipeline inputs
    reg [31:0] a_reg, b_reg;

    // 64-bit accumulator register
    reg [63:0] acc;

    // Register inputs at clock edge
    always @(posedge clk) begin
        if (rst) begin
            a_reg <= 32'd0;
            b_reg <= 32'd0;
        end else begin
            a_reg <= a;
            b_reg <= b;
        end
    end

    // Combinational multiplication of registered inputs
    wire [63:0] product = a_reg * b_reg;

    // Accumulate product into acc register
    always @(posedge clk) begin
        if (rst) begin
            acc <= 64'd0;
        end else begin
            acc <= acc + product;
        end
    end

    // Output the lower 32 bits of accumulator
    assign c = acc[31:0];

endmodule