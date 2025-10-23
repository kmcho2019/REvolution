module pe (
    input  wire        clk,
    input  wire        rst,    // synchronous reset: active high
    input  wire [31:0] a,
    input  wire [31:0] b,
    output reg  [31:0] c
);

    reg [31:0] acc;

    wire [63:0] product_full;
    wire [31:0] product_trunc;
    wire [32:0] sum_ext;
    wire        overflow;

    assign product_full = a * b;
    assign product_trunc = product_full[31:0]; // truncate to lower 32 bits

    assign sum_ext = {1'b0, acc} + {1'b0, product_trunc};
    assign overflow = sum_ext[32];

    always @(posedge clk) begin
        if (rst) begin
            acc <= 32'd0;
        end else begin
            if (overflow)
                acc <= 32'hFFFFFFFF;  // saturate on overflow
            else
                acc <= sum_ext[31:0];
        end
    end

    always @(*) begin
        c = acc;
    end

endmodule