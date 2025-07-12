module TopModule (
    input clk,
    input reset,
    output reg [9:0] q
);

    // Split the 10-bit counter into a 4-bit high and 6-bit low part for comparison
    wire [3:0] high_part = q[9:6];
    wire [5:0] low_part = q[5:0];

    always @(posedge clk) begin
        if (reset) begin
            q <= 10'b0;
        end else begin
            // Increment counter
            if (high_part == 4'd15 && low_part == 6'd39) begin
                // 15 * 64 + 39 = 960 + 39 = 999 decimal
                q <= 10'b0;
            end else begin
                q <= q + 1'b1;
            end
        end
    end

endmodule