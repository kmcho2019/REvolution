module TopModule (
    input clk,
    input reset,
    input ena,
    output pm,
    output [7:0] hh,
    output [7:0] mm,
    output [7:0] ss
);

    reg [5:0] sec;  // 0-59
    reg [5:0] min;  // 0-59
    reg [4:0] hour; // 1-12
    reg pm_reg;
    
    wire sec_rollover = (sec == 6'd59);
    wire min_rollover = (min == 6'd59) & sec_rollover;

    always @(posedge clk) begin
        if (reset) begin
            sec <= 6'd0;
            min <= 6'd0;
            hour <= 5'd12;
            pm_reg <= 1'b0;
        end else if (ena) begin
            // Seconds counter
            if (sec_rollover) begin
                sec <= 6'd0;
                // Minutes counter
                if (min_rollover) begin
                    min <= 6'd0;
                    // Hours counter
                    if (hour == 5'd12)
                        hour <= 5'd1;
                    else
                        hour <= hour + 1;
                    // PM toggle at 11->12
                    if (hour == 5'd11)
                        pm_reg <= ~pm_reg;
                end else begin
                    min <= min + 1;
                end
            end else begin
                sec <= sec + 1;
            end
        end
    end

    // Convert binary to BCD for outputs
    assign ss = {sec[5:4], 2'b0} + {4'b0, sec[3:0]};  // sec/10 in upper nibble, sec%10 in lower
    assign mm = {min[5:4], 2'b0} + {4'b0, min[3:0]};  // same for minutes
    assign hh = (hour > 5'd9) ? 8'h1_0 + (hour - 5'd10) : 8'h0_0 + hour;
    assign pm = pm_reg;

endmodule