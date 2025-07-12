module TopModule (
    input clk,
    input reset,
    input ena,
    output pm,
    output [7:0] hh,
    output [7:0] mm,
    output [7:0] ss
);

    // State representation: {hour_tens, hour_ones, min_tens, min_ones, sec_tens, sec_ones}
    reg [23:0] time_state;
    reg pm_reg;

    // BCD constants for comparison
    parameter BCD_0 = 4'd0, BCD_5 = 4'd5, BCD_9 = 4'd9;
    parameter BCD_12 = 4'd12, BCD_11 = 4'd11;

    // State transitions
    always @(posedge clk) begin
        if (reset) begin
            time_state <= {4'd1, 4'd2, 4'd0, 4'd0, 4'd0, 4'd0}; // 12:00:00
            pm_reg <= 1'b0;
        end else if (ena) begin
            // Seconds increment
            if (time_state[3:0] == BCD_9) begin
                time_state[3:0] <= BCD_0;
                if (time_state[7:4] == BCD_5) begin
                    time_state[7:4] <= BCD_0;
                    // Minutes increment
                    if (time_state[11:8] == BCD_9) begin
                        time_state[11:8] <= BCD_0;
                        if (time_state[15:12] == BCD_5) begin
                            time_state[15:12] <= BCD_0;
                            // Hours increment and PM toggle
                            if (time_state[23:20] == 4'd1 && time_state[19:16] == 4'd2) begin
                                time_state[23:16] <= {4'd0, 4'd1}; // 12 -> 01
                            end else if (time_state[19:16] == BCD_9) begin
                                time_state[23:16] <= {time_state[23:20] + 1, BCD_0};
                            end else begin
                                time_state[19:16] <= time_state[19:16] + 1;
                            end
                            // Toggle PM at 11->12 transition
                            if (time_state[23:16] == {4'd0, BCD_11}) begin
                                pm_reg <= ~pm_reg;
                            end
                        end else begin
                            time_state[15:12] <= time_state[15:12] + 1;
                        end
                    end else begin
                        time_state[11:8] <= time_state[11:8] + 1;
                    end
                end else begin
                    time_state[7:4] <= time_state[7:4] + 1;
                end
            end else begin
                time_state[3:0] <= time_state[3:0] + 1;
            end
        end
    end

    // Output assignments
    assign ss = time_state[7:0];
    assign mm = time_state[15:8];
    assign hh = time_state[23:16];
    assign pm = pm_reg;

endmodule