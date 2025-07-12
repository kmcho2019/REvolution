module TopModule(
    input  wire       clk,
    input  wire       reset,
    input  wire       ena,
    output wire       pm,
    output wire [7:0] hh,
    output wire [7:0] mm,
    output wire [7:0] ss
);

    reg [5:0] seconds; // 0-59
    reg [5:0] minutes; // 0-59
    reg [3:0] hours;   // 1-12
    reg       pm_reg;

    // Synchronous counting logic
    always @(posedge clk) begin
        if (reset) begin
            seconds <= 6'd0;
            minutes <= 6'd0;
            hours   <= 4'd12;
            pm_reg  <= 1'b0; // AM
        end else if (ena) begin
            if (seconds == 6'd59) begin
                seconds <= 6'd0;
                if (minutes == 6'd59) begin
                    minutes <= 6'd0;
                    if (hours == 4'd11) begin
                        hours  <= 4'd12;
                        pm_reg <= ~pm_reg; // Toggle AM/PM on 11->12
                    end else if (hours == 4'd12) begin
                        hours <= 4'd1;
                    end else begin
                        hours <= hours + 1;
                    end
                end else begin
                    minutes <= minutes + 1;
                end
            end else begin
                seconds <= seconds + 1;
            end
        end
    end

    assign pm = pm_reg;

    // BCD conversion using arithmetic operators for outputs
    // Seconds
    assign ss[7:4] = seconds / 10;
    assign ss[3:0] = seconds % 10;

    // Minutes
    assign mm[7:4] = minutes / 10;
    assign mm[3:0] = minutes % 10;

    // Hours (1-12)
    assign hh[7:4] = hours / 10;
    assign hh[3:0] = hours % 10;

endmodule