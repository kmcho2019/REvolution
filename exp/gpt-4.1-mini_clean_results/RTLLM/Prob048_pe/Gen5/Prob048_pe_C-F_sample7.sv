module pe (
    input  wire        clk,
    input  wire        rst,        // synchronous reset, active high
    input  wire [31:0] a,
    input  wire [31:0] b,
    output wire [31:0] c
);

    reg  [63:0] accumulator;
    wire [63:0] product;

    assign product = a * b;
    assign c = accumulator[31:0];  // output lower 32 bits

    always @(posedge clk) begin
        if (rst)
            accumulator <= 64'd0;
        else
            accumulator <= accumulator + product;
    end

endmodule