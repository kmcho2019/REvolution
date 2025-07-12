module TopModule(
    input clk,
    input reset,
    input ena,
    output reg pm,
    output reg [7:0] hh,
    output reg [7:0] mm,
    output reg [7:0] ss
);

// Internal signals
reg [3:0] hours;
reg [5:0] minutes;
reg [5:0] seconds;

// Counter modules
always @(posedge clk) begin
    if (reset) begin
        hours <= 4'd0;
        minutes <= 6'd0;
        seconds <= 6'd0;
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

// Centralized controller
always @(posedge clk) begin
    if (reset) begin
        pm <= 1'b0;
    end else if (ena) begin
        // Update AM/PM indicator
        if (hours >= 4'd12) begin
            pm <= 1'b1;
        end else begin
            pm <= 1'b0;
        end
    end
end

// Decoder module
always @(posedge clk) begin
    // Convert hours to BCD
    if (hours == 4'd0) begin
        hh <= 8'd12;
    end else if (hours <= 4'd9) begin
        hh <= {4'd0, hours};
    end else begin
        hh <= {4'd1, hours - 4'd10};
    end

    // Convert minutes to BCD
    mm <= {4'd0, minutes[4:0]};

    // Convert seconds to BCD
    ss <= {4'd0, seconds[4:0]};
end

endmodule