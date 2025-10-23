module TopModule(
    input clk,
    input reset,
    input ena,
    output reg pm,
    output reg [7:0] hh,
    output reg [7:0] mm,
    output reg [7:0] ss
);

// Internal counters for seconds, minutes, and hours
reg [5:0] seconds;
reg [5:0] minutes;
reg [3:0] hours; // Using 4 bits for hours to represent 0-11

// Reset and update counters and signals
always @(posedge clk) begin
    if (reset) begin
        // Reset counters and signals to initial states
        seconds <= 6'd0;
        minutes <= 6'd0;
        hours <= 4'd0; // 0 represents 12 AM
        pm <= 1'b0;
        hh <= 8'd12; // Display 12 for hours
        mm <= 8'd0; // Reset minutes display to 0
        ss <= 8'd0; // Reset seconds display to 0
    end else if (ena) begin
        // Increment seconds counter
        if (seconds == 6'd59) begin
            seconds <= 6'd0;
            // Increment minutes counter
            if (minutes == 6'd59) begin
                minutes <= 6'd0;
                // Increment hours counter
                if (hours == 4'd11) begin
                    hours <= 4'd0;
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
    // Update output signals
    ss <= {2'b0, seconds}; // Convert seconds to BCD
    mm <= {2'b0, minutes}; // Convert minutes to BCD
    case (hours)
        4'd0: hh <= 8'd12; // Display 12 for 0 hours
        default: hh <= {4'b0, hours}; // Convert hours to BCD
    endcase
    pm <= (hours >= 4'd6) ? 1'b1 : 1'b0; // Update PM indicator
end

endmodule