module TopModule(
    input clk,
    input reset,
    input ena,
    output reg pm,
    output reg [7:0] hh,
    output reg [7:0] mm,
    output reg [7:0] ss
);

// BCD digit increment helper function
function [3:0] bcd_inc;
    input [3:0] digit;
    begin
        if (digit == 4'd9)
            bcd_inc = 4'd0;
        else
            bcd_inc = digit + 4'd1;
    end
endfunction

// BCD digit comparison helper function
function bcd_eq;
    input [3:0] a;
    input [3:0] b;
    begin
        bcd_eq = (a == b);
    end
endfunction

// Increment seconds BCD (00-59)
task inc_seconds;
    begin
        // increment units digit
        if (ss[3:0] == 4'd9) begin
            ss[3:0] <= 4'd0;
            // increment tens digit
            if (ss[7:4] == 4'd5) begin
                ss[7:4] <= 4'd0;
                // signal minute increment
                inc_minute_flag <= 1'b1;
            end else begin
                ss[7:4] <= ss[7:4] + 4'd1;
                inc_minute_flag <= 1'b0;
            end
        end else begin
            ss[3:0] <= ss[3:0] + 4'd1;
            inc_minute_flag <= 1'b0;
        end
    end
endtask

// Increment minutes BCD (00-59)
task inc_minutes;
    begin
        // increment units digit
        if (mm[3:0] == 4'd9) begin
            mm[3:0] <= 4'd0;
            // increment tens digit
            if (mm[7:4] == 4'd5) begin
                mm[7:4] <= 4'd0;
                // signal hour increment
                inc_hour_flag <= 1'b1;
            end else begin
                mm[7:4] <= mm[7:4] + 4'd1;
                inc_hour_flag <= 1'b0;
            end
        end else begin
            mm[3:0] <= mm[3:0] + 4'd1;
            inc_hour_flag <= 1'b0;
        end
    end
endtask

// Increment hours BCD (01-12)
task inc_hours;
    reg [7:0] next_hh;
    begin
        // Convert BCD hour to integer for easier increment logic
        // hh[7:4] = tens digit, hh[3:0] = units digit
        // Valid hours: 01 to 12
        // We'll increment hour and wrap accordingly
        // Also toggle pm when hour rolls from 11 to 12

        // Convert BCD to integer
        integer hour_int;
        hour_int = hh[7:4]*10 + hh[3:0];

        hour_int = hour_int + 1;
        if (hour_int == 13) begin
            hour_int = 1;
        end

        // Update pm flag when hour rolls from 11 to 12
        // So if previous hour was 11 and now 12, toggle pm
        if ((hh[7:4]*10 + hh[3:0]) == 11 && hour_int == 12) begin
            pm <= ~pm;
        end

        // Convert back to BCD
        hh[7:4] <= hour_int / 10;
        hh[3:0] <= hour_int % 10;
    end
endtask

reg inc_minute_flag;
reg inc_hour_flag;

always @(posedge clk) begin
    if (reset) begin
        // Reset to 12:00:00 AM
        pm <= 1'b0;
        hh <= 8'h12; // 0x12 BCD = 12
        mm <= 8'h00;
        ss <= 8'h00;
        inc_minute_flag <= 1'b0;
        inc_hour_flag <= 1'b0;
    end else if (ena) begin
        inc_minute_flag <= 1'b0;
        inc_hour_flag <= 1'b0;

        // Increment seconds
        // Use the task to increment seconds and set inc_minute_flag if needed
        // Because tasks cannot have output, we use reg flags
        inc_seconds();

        // If seconds rolled over, increment minutes
        if (inc_minute_flag) begin
            inc_minutes();
        end

        // If minutes rolled over, increment hours
        if (inc_hour_flag) begin
            inc_hours();
        end
    end
end

endmodule