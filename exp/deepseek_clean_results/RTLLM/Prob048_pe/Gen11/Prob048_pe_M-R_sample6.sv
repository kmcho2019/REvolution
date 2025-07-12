module pe (
    input wire clk,
    input wire rst,
    input wire signed [31:0] a,
    input wire signed [31:0] b,
    output reg signed [31:0] c
);

    // Registered accumulation
    always @(posedge clk) begin
        if (rst) begin
            c <= 32'd0;
        end else begin
            // Accumulate with 32-bit truncation (lower bits)
            c <= c + (a * b);
        end
    end

endmodule