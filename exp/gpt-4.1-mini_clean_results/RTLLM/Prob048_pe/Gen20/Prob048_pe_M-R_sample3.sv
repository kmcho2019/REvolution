module pe (
    input           clk,
    input           rst,    // synchronous active-high reset
    input  [31:0]   a,
    input  [31:0]   b,
    output reg [31:0] c
);

    // Combinational multiplication
    wire [63:0] product = a * b;

    // Intermediate sum with overflow bit
    reg [32:0] sum_ext;

    always @(*) begin
        sum_ext = {1'b0, c} + product[31:0];
    end

    always @(posedge clk) begin
        if (rst) begin
            c <= 32'd0;
        end else begin
            if (sum_ext[32])
                c <= 32'hFFFF_FFFF; // saturate at max 32-bit unsigned value
            else
                c <= sum_ext[31:0];
        end
    end

endmodule