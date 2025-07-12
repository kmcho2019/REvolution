module pe (
    input  wire        clk,
    input  wire        rst,      // asynchronous active-high reset
    input  wire        enable,   // new input: accumulation enable
    input  wire [31:0] a,
    input  wire [31:0] b,
    output wire [31:0] c
);

    // Stage 1: register inputs and product to pipeline multiplication
    reg [31:0] a_reg, b_reg;
    reg [63:0] product_reg;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            a_reg <= 32'd0;
            b_reg <= 32'd0;
            product_reg <= 64'd0;
        end else begin
            a_reg <= a;
            b_reg <= b;
            product_reg <= a_reg * b_reg;  // registered multiplication result
        end
    end

    // Stage 2: accumulator register (64-bit) with enable gating
    reg [63:0] acc;
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            acc <= 64'd0;
        end else if (enable) begin
            acc <= acc + product_reg;
        end
    end

    // Output lower 32 bits of accumulator
    assign c = acc[31:0];

endmodule