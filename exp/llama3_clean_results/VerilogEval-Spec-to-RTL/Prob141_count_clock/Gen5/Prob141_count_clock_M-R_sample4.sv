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
                end else if (hours == 4'd12) begin
                    hours <= 4'd1;
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
assign ss = {2'b0, seconds};
assign mm = {2'b0, minutes};

always @(posedge clk) begin
    if (reset) begin
        hh <= 8'd12; // Reset hours to 12
    end else begin
        // Convert hours to BCD
        if (hours == 4'd0) begin
            hh <= 8'd12; // 12 AM/PM
        end else if (hours == 4'd12) begin
            hh <= 8'd12; // 12 PM
        end else if (hours > 4'd12) begin
            hh <= {4'b0, hours - 4'd12}; // Directly assign hours to BCD
        end else begin
            hh <= {4'b0, hours}; // Directly assign hours to BCD
        end
    end
end

endmodule