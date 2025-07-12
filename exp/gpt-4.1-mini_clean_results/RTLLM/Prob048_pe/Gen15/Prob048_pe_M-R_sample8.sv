module pe (
    input  wire        clk,
    input  wire        rst,    // synchronous active-high reset
    input  wire [31:0] a,
    input  wire [31:0] b,
    output reg  [31:0] c      // output lower 32 bits of accumulator
);

    reg [63:0] acc;           // 64-bit accumulator register
    wire [63:0] product;

    assign product = a * b;

    // Accumulate product into acc on rising clock, reset clears acc
    always @(posedge clk) begin
        if (rst) begin
            acc <= 64'd0;
            c   <= 32'd0;
        end else begin
            acc <= acc + product;
            c   <= (acc + product)[31:0];
        end
    end

endmodule