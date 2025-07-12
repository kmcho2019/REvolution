module pe (
    input  wire        clk,
    input  wire        rst,    // synchronous reset: active high
    input  wire [31:0] a,
    input  wire [31:0] b,
    output reg  [31:0] c
);

    reg [31:0] acc;

    always @(posedge clk) begin
        if (rst) begin
            acc <= 32'd0;
        end else begin
            // Perform multiplication
            // Multiply a and b producing 64-bit result
            // Truncate lower 32 bits and accumulate with saturation
            reg [63:0] product_full;
            reg [32:0] sum_ext;
            reg        overflow;
            
            product_full = a * b;
            // sum_ext = acc + product_trunc (lower 32 bits)
            sum_ext = {1'b0, acc} + {1'b0, product_full[31:0]};
            overflow = sum_ext[32];

            if (overflow)
                acc <= 32'hFFFFFFFF;
            else
                acc <= sum_ext[31:0];
        end
    end

    // Drive output synchronously from acc register
    always @(posedge clk) begin
        c <= acc;
    end

endmodule