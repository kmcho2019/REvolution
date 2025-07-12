module pe (
    input               clk,
    input               rst,    // async active-high reset
    input       [31:0]  a,
    input       [31:0]  b,
    output reg  [31:0]  c
);

    reg [31:0] accumulator;
    wire [63:0] product;
    wire [63:0] sum_64;
    wire overflow;

    assign product = a * b;
    assign sum_64 = {32'd0, accumulator} + product;
    assign overflow = |sum_64[63:32];  // any upper bits set indicates overflow

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            accumulator <= 32'd0;
        end else begin
            if (overflow)
                accumulator <= 32'hFFFFFFFF; // saturate to max 32-bit unsigned
            else
                accumulator <= sum_64[31:0];
        end
    end

    always @(*) begin
        c = accumulator;
    end

endmodule