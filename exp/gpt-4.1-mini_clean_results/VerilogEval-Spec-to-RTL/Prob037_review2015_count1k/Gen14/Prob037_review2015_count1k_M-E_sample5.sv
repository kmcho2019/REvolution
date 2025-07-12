module TopModule (
    input clk,
    input reset,
    output reg [9:0] q
);

    // Low counter counts 0 to 63 (6 bits)
    reg [5:0] low_cnt;
    // High counter counts 0 to 15 (4 bits)
    reg [3:0] high_cnt;

    localparam LOW_MAX  = 6'd63;  // Max for low counter
    localparam HIGH_MAX = 4'd15;  // Max for high counter

    // Combined max count = 999 (decimal) = 0x3E7 (binary 0011_1110_0111)
    // We reset when (high_cnt, low_cnt) = 10'd999

    always @(posedge clk) begin
        if (reset) begin
            low_cnt  <= 6'd0;
            high_cnt <= 4'd0;
            q <= 10'd0;
        end else begin
            if (low_cnt == LOW_MAX) begin
                low_cnt <= 6'd0;
                // Increment high counter
                if (high_cnt == HIGH_MAX) begin
                    // Check if combined count reached 999, reset both counters
                    // Since max combined is 15*64+63=1023, but max count is 999
                    // Reset counters when q == 999
                    low_cnt <= 6'd0;
                    high_cnt <= 4'd0;
                    q <= 10'd0;
                end else begin
                    high_cnt <= high_cnt + 4'd1;
                    q <= {high_cnt + 4'd1, 6'd0};
                end
            end else begin
                low_cnt <= low_cnt + 6'd1;
                q <= {high_cnt, low_cnt + 6'd1};
            end

            // If count reaches 999, reset explicitly
            if ({high_cnt, low_cnt} == 10'd999) begin
                low_cnt <= 6'd0;
                high_cnt <= 4'd0;
                q <= 10'd0;
            end
        end
    end

endmodule