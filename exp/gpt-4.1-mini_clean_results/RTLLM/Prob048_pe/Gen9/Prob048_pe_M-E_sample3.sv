module pe (
    input           clk,
    input           rst,
    input  [31:0]   a,
    input  [31:0]   b,
    output reg [31:0]   c
);

    reg [31:0] acc;

    wire [63:0] product = a * b;
    wire [32:0] sum_ext = {1'b0, acc} + product[31:0];

    // Saturate addition: if overflow, saturate at max 32'hFFFF_FFFF
    wire overflow = sum_ext[32];

    always @(posedge clk) begin
        if (rst) begin
            acc <= 32'd0;
        end else begin
            if (overflow)
                acc <= 32'hFFFF_FFFF; // Saturate max positive value
            else
                acc <= sum_ext[31:0];
        end
    end

    always @(*) begin
        c = acc;
    end

endmodule