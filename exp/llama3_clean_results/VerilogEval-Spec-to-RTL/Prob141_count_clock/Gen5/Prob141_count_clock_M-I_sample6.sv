module TopModule(
    input clk,
    input reset,
    input ena,
    output reg pm,
    output reg [7:0] hh,
    output reg [7:0] mm,
    output reg [7:0] ss
);

// Internal counters
reg [5:0] seconds;
reg [5:0] minutes;
reg [4:0] hours;

// State machine for seconds, minutes, and hours
always @(posedge clk) begin
    if (reset) begin
        seconds <= 6'd0;
        minutes <= 6'd0;
        hours <= 4'd0;
        pm <= 1'b0;
    end else if (ena) begin
        // Increment seconds
        if (seconds == 6'd59) begin
            seconds <= 6'd0;
            // Increment minutes
            if (minutes == 6'd59) begin
                minutes <= 6'd0;
                // Increment hours
                if (hours == 4'd11) begin
                    hours <= 4'd0;
                    pm <= ~pm;
                end else begin
                    hours <= hours + 1'b1;
                end
            end else begin
                minutes <= minutes + 1'b1;
            end
        end else begin
            seconds <= seconds + 1'b1;
        end
    end
end

// Output conversion logic
always @(posedge clk) begin
    if (reset) begin
        hh <= 8'd12; // Reset hours to 12
        mm <= 8'd0; // Reset minutes to 0
        ss <= 8'd0; // Reset seconds to 0
    end else begin
        // Convert seconds to BCD
        ss <= {4'b0, seconds[3:0], 2'b0, seconds[5:4]};
        
        // Convert minutes to BCD
        mm <= {4'b0, minutes[3:0], 2'b0, minutes[5:4]};
        
        // Convert hours to BCD
        if (hours == 4'd0) begin
            hh <= 8'd12; // 12 AM/PM
        end else if (hours < 4'd10) begin
            hh <= {4'b0, hours, 2'b0, 2'b0}; // Directly assign hours to BCD
        end else begin
            hh <= {4'b1, hours - 4'd10, 2'b0, 2'b0}; // Adjust hours for BCD
        end
    end
end

endmodule