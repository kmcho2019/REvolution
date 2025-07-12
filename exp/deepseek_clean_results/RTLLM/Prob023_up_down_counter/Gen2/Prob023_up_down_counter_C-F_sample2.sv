module up_down_counter #(
    parameter WIDTH = 16
) (
    input clk,
    input reset,
    input up_down,
    input enable,        // Clock gating control
    output [WIDTH-1:0] count
);

reg [WIDTH-1:0] gray_count;
reg [WIDTH-1:0] binary_count;

// Gray code counter
always @(posedge clk) begin
    if (reset) begin
        gray_count <= {WIDTH{1'b0}};
    end else if (enable) begin
        if (up_down) begin
            // Increment: XOR with 1 shifted left by trailing zero count
            gray_count <= gray_count ^ ((gray_count & -gray_count) << 1);
        end else begin
            // Decrement: XOR with 1 shifted left by trailing one count
            gray_count <= gray_count ^ (1'b1 << (WIDTH - $clog2(~gray_count & (gray_count + 1))));
        end
    end
end

// Gray to binary conversion
genvar i;
generate
    for (i = 0; i < WIDTH; i = i + 1) begin : gray2bin
        always @(*) begin
            binary_count[i] = ^(gray_count >> i);
        end
    end
endgenerate

assign count = binary_count;

endmodule