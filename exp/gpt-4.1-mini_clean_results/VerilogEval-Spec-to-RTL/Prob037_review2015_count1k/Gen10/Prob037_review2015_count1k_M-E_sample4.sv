module TopModule (
    input clk,
    input reset,
    output reg [9:0] q
);

    // Terminal count constant
    localparam MAX_COUNT = 10'd999;

    // Detect when q == MAX_COUNT
    wire is_max_count;
    // Instead of splitting bits, implement equality as a single LUT
    // q == 999 decimal (binary 10'b 11_1110_0111)
    assign is_max_count = (q == MAX_COUNT);

    always @(posedge clk) begin
        if (reset) begin
            q <= 10'd0;
        end else if (is_max_count) begin
            q <= 10'd0;
        end else begin
            q <= q + 10'd1;
        end
    end

endmodule