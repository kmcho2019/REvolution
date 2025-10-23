module TopModule (
    input clk,
    input reset,
    input ena,
    output pm,
    output [7:0] hh,
    output [7:0] mm,
    output [7:0] ss
);

    // State registers
    reg [3:0] sec_ones;
    reg [2:0] sec_tens;
    reg [3:0] min_ones;
    reg [2:0] min_tens;
    reg [3:0] hour;
    reg pm_reg;

    // Registered rollover signals
    reg sec_rollover;
    reg min_rollover;

    // Continuous output assignments
    assign ss = {sec_tens, 1'b0, sec_ones}; // BCD format
    assign mm = {min_tens, 1'b0, min_ones}; // BCD format
    assign hh = (hour > 9) ? {4'd1, hour - 4'd10} : {4'd0, hour};
    assign pm = pm_reg;

    // Unified state machine
    always @(posedge clk) begin
        if (reset) begin
            // Reset to 12:00:00 AM
            sec_ones <= 4'd0;
            sec_tens <= 3'd0;
            min_ones <= 4'd0;
            min_tens <= 3'd0;
            hour <= 4'd12;
            pm_reg <= 1'b0;
            sec_rollover <= 1'b0;
            min_rollover <= 1'b0;
        end
        else if (ena) begin
            // Seconds counter
            if (sec_ones == 4'd9) begin
                sec_ones <= 4'd0;
                if (sec_tens == 3'd5) begin
                    sec_tens <= 3'd0;
                    sec_rollover <= 1'b1;
                end
                else begin
                    sec_tens <= sec_tens + 1;
                    sec_rollover <= 1'b0;
                end
            end
            else begin
                sec_ones <= sec_ones + 1;
                sec_rollover <= 1'b0;
            end

            // Minutes counter (only on second rollover)
            if (sec_rollover) begin
                if (min_ones == 4'd9) begin
                    min_ones <= 4'd0;
                    if (min_tens == 3'd5) begin
                        min_tens <= 3'd0;
                        min_rollover <= 1'b1;
                    end
                    else begin
                        min_tens <= min_tens + 1;
                        min_rollover <= 1'b0;
                    end
                end
                else begin
                    min_ones <= min_ones + 1;
                    min_rollover <= 1'b0;
                end
            end

            // Hours counter (only on minute rollover)
            if (min_rollover) begin
                if (hour == 4'd12) begin
                    hour <= 4'd1;
                end
                else begin
                    hour <= hour + 1;
                end

                // Toggle PM at 11->12 transition
                if (hour == 4'd11) begin
                    pm_reg <= ~pm_reg;
                end
            end
        end
    end

endmodule