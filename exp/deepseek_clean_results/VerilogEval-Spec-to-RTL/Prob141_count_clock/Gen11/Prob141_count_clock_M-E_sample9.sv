module TopModule (
    input clk,
    input reset,
    input ena,
    output pm,
    output [7:0] hh,
    output [7:0] mm,
    output [7:0] ss
);

    // Total seconds counter (0-43199 for 12 hours)
    reg [16:0] seconds_since_midnight;
    reg pm_state;
    
    // Clock gating logic
    wire counter_en = ena && !reset;
    
    always @(posedge clk) begin
        if (reset) begin
            seconds_since_midnight <= 17'd0;
            pm_state <= 1'b0;
        end else if (counter_en) begin
            if (seconds_since_midnight == 17'd43199) begin // 12 hours - 1 second
                seconds_since_midnight <= 17'd0;
                pm_state <= ~pm_state;
            end else begin
                seconds_since_midnight <= seconds_since_midnight + 1;
            end
        end
    end

    // Time calculation
    wire [5:0] total_seconds = seconds_since_midnight % 60;
    wire [5:0] total_minutes = (seconds_since_midnight / 60) % 60;
    wire [4:0] total_hours = (seconds_since_midnight / 3600) % 12;
    wire [4:0] display_hour = (total_hours == 0) ? 5'd12 : total_hours;

    // Optimized BCD conversion (parallel implementation)
    wire [7:0] bcd_ss = {
        4'(total_seconds / 10),  // seconds tens
        4'(total_seconds % 10)   // seconds ones
    };
    
    wire [7:0] bcd_mm = {
        4'(total_minutes / 10),  // minutes tens
        4'(total_minutes % 10)   // minutes ones
    };
    
    wire [7:0] bcd_hh = {
        4'(display_hour / 10),   // hour tens (always 0 or 1)
        4'(display_hour % 10)    // hour ones
    };

    // Output assignments
    assign ss = reset ? 8'h00 : bcd_ss;
    assign mm = reset ? 8'h00 : bcd_mm;
    assign hh = reset ? 8'h12 : bcd_hh;
    assign pm = reset ? 1'b0 : pm_state;

endmodule