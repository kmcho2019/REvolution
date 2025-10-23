module TopModule (
    input clk,
    input reset,
    output reg [9:0] q
);

    reg [3:0] high_cnt;
    reg [5:0] low_cnt;

    // Constants for terminal counts
    localparam LOW_MAX  = 6'd39;
    localparam HIGH_MAX = 4'd15;

    always @(posedge clk) begin
        if (reset) begin
            high_cnt <= 4'd0;
            low_cnt  <= 6'd0;
        end else begin
            if (low_cnt == LOW_MAX) begin
                low_cnt <= 6'd0;
                if (high_cnt == HIGH_MAX)
                    high_cnt <= 4'd0;
                else
                    high_cnt <= high_cnt + 4'd1;
            end else begin
                low_cnt <= low_cnt + 6'd1;
            end
        end
    end

    always @(*) begin
        q = {high_cnt, low_cnt};
    end

endmodule