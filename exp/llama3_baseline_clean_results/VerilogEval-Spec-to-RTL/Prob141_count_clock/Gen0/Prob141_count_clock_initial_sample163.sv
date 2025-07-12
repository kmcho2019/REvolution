module TopModule(
    input  clk, 
    input  reset, 
    input  ena, 
    output reg pm, 
    output reg [7:0] hh, 
    output reg [7:0] mm, 
    output reg [7:0] ss
);

    // Initialize counters
    reg [3:0] seconds;
    reg [5:0] minutes;
    reg [3:0] hours;

    // Increment counters on enable
    always @ (posedge clk) begin
        if (reset) begin
            // Reset to "12:00 AM"
            seconds <= 0;
            minutes <= 0;
            hours <= 0;
            pm <= 0;
        end else if (ena) begin
            // Increment seconds
            if (seconds == 9'd59) begin
                seconds <= 0;
                // Increment minutes
                if (minutes == 6'd59) begin
                    minutes <= 0;
                    // Increment hours
                    if (hours == 4'd11) begin
                        hours <= 1;
                        pm <= 1'b0;
                    end else if (hours == 4'd12) begin
                        hours <= 1;
                        pm <= 1'b1;
                    end else begin
                        hours <= hours + 1;
                        // Switch from AM to PM
                        if (hours == 4'd12) begin
                            pm <= 1'b1;
                        end
                    end
                end else begin
                    minutes <= minutes + 1;
                end
            end else begin
                seconds <= seconds + 1;
            end
        end
    end

    // Update BCD outputs
    always @ (*) begin
        hh[3:0] = hours;
        hh[7:4] = 4'b0;
        mm[3:0] = minutes[5:2];
        mm[7:4] = minutes[1:0];
        ss[3:0] = seconds[5:2];
        ss[7:4] = seconds[1:0];
    end

    // PM indicator
    always @ (*) begin
        if (hours > 4'd11) begin
            pm = 1'b1;
        end else begin
            pm = 1'b0;
        end
    end

endmodule