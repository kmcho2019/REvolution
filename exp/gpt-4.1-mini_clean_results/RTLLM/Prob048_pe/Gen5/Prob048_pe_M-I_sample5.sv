module pe (
    input           clk,
    input           rst,
    input  [31:0]   a,
    input  [31:0]   b,
    output [31:0]   c
);

    // Internal registers
    reg [63:0] acc;         // 64-bit accumulator
    reg [63:0] product_r;   // Registered product to pipeline multiplication

    wire [63:0] product = a * b;   // Combinational multiply

    // Enable accumulation only when product is not zero (helps reduce switching)
    wire accum_en = (product != 64'd0);

    // Pipeline stage: register the product on clk
    always @(posedge clk) begin
        if (rst) begin
            product_r <= 64'd0;
        end else begin
            product_r <= product;
        end
    end

    // Accumulate registered product into accumulator on clk with enable
    always @(posedge clk) begin
        if (rst) begin
            acc <= 64'd0;
        end else if (accum_en) begin
            acc <= acc + product_r;
        end
        // else no update to acc (retains previous value, reducing toggling)
    end

    // Output lower 32 bits of accumulator
    assign c = acc[31:0];

endmodule