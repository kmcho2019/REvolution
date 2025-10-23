module pe (
    input  wire        clk,
    input  wire        rst,    // synchronous active-high reset
    input  wire [31:0] a,
    input  wire [31:0] b,
    output wire [31:0] c
);

    // Pipeline stage 1 registers for inputs
    reg [31:0] a_reg, b_reg;
    always @(posedge clk) begin
        if (rst) begin
            a_reg <= 32'd0;
            b_reg <= 32'd0;
        end else begin
            a_reg <= a;
            b_reg <= b;
        end
    end

    // Combinational product of registered inputs
    wire [63:0] product = a_reg * b_reg;

    // Stage 2 accumulator register
    reg [63:0] acc;
    always @(posedge clk) begin
        if (rst) begin
            acc <= 64'd0;
        end else begin
            acc <= acc + product;
        end
    end

    // Output lower 32 bits of accumulator
    assign c = acc[31:0];

endmodule