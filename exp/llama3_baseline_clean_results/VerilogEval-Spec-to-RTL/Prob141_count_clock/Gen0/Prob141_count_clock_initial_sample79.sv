module TopModule(
    input  clk,
    input  reset,
    input  ena,
    output reg pm,
    output reg [7:0] hh,
    output reg [7:0] mm,
    output reg [7:0] ss
);

    // Internal signals
    reg [7:0] hours;
    reg [7:0] minutes;
    reg [7:0] seconds;

    // Reset values
    localparam RESET_HOURS = 8'h12;  // 12 in BCD
    localparam RESET_MINUTES = 8'h00;  // 00 in BCD
    localparam RESET_SECONDS = 8'h00;  // 00 in BCD

    // Increment values
    localparam INC_HOURS = 8'h01;  // 01 in BCD
    localparam INC_MINUTES = 8'h01;  // 01 in BCD
    localparam INC_SECONDS = 8'h01;  // 01 in BCD

    // Maximum values
    localparam MAX_HOURS = 8'h12;  // 12 in BCD
    localparam MAX_MINUTES = 8'h59;  // 59 in BCD
    localparam MAX_SECONDS = 8'h59;  // 59 in BCD

    // Update counters
    always @(posedge clk) begin
        if (reset) begin
            hours <= RESET_HOURS;
            minutes <= RESET_MINUTES;
            seconds <= RESET_SECONDS;
            pm <= 0;  // AM
        end else if (ena) begin
            if (seconds == MAX_SECONDS) begin
                seconds <= 8'h00;  // Reset seconds to 00
                if (minutes == MAX_MINUTES) begin
                    minutes <= 8'h00;  // Reset minutes to 00
                    if (hours == MAX_HOURS) begin
                        hours <= 8'h01;  // Reset hours to 01
                        pm <= ~pm;  // Toggle AM/PM
                    end else begin
                        hours <= hours + INC_HOURS;
                    end
                end else begin
                    minutes <= minutes + INC_MINUTES;
                end
            end else begin
                seconds <= seconds + INC_SECONDS;
            end
        end
    end

    // Assign outputs
    assign hh = hours;
    assign mm = minutes;
    assign ss = seconds;

endmodule