module TopModule(
    input clk,
    input reset,
    input ena,
    output reg pm,
    output reg [7:0] hh,
    output reg [7:0] mm,
    output reg [7:0] ss
);

    always @(posedge clk) begin
        if (reset) begin // Active high reset
            pm <= 0; // Reset to AM
            hh <= 8'h01; // Reset hours to 01
            mm <= 8'h00; // Reset minutes to 00
            ss <= 8'h00; // Reset seconds to 00
        end else if (ena) begin // Increment only when ena is high
            if (ss == 8'd59) begin // If seconds are at 59
                ss <= 8'h00; // Reset seconds to 00
                if (mm == 8'd59) begin // If minutes are at 59
                    mm <= 8'h00; // Reset minutes to 00
                    if (hh == 8'd12) begin // If hours are at 12
                        hh <= 8'h01; // Reset hours to 01
                        pm <= ~pm; // Toggle AM/PM
                    end else if (hh == 8'h12 - 1) begin // Special case for 11 to 12 transition
                        hh <= 8'h12; // Move to 12
                    end else begin
                        hh <= hh + 8'd1; // Increment hours
                    end
                end else begin
                    mm <= mm + 8'd1; // Increment minutes
                end
            end else begin
                ss <= ss + 8'd1; // Increment seconds
            end
        end
    end

endmodule