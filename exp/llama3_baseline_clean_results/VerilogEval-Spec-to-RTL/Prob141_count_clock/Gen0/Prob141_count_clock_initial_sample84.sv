module TopModule(
    input clk, // fast clock
    input reset, // active high reset
    input ena, // enable increment (1-second pulse)
    output pm, // pm/am indicator
    output [7:0] hh, // hours (01-12 in BCD)
    output [7:0] mm, // minutes (00-59 in BCD)
    output [7:0] ss // seconds (00-59 in BCD)
);

reg [3:0] hours; // internal hours counter (0-12)
reg [5:0] minutes; // internal minutes counter (0-59)
reg [5:0] seconds; // internal seconds counter (0-59)

// Reset to initial values when reset is high
always @(posedge clk) begin
    if (reset) begin
        hours <= 4'd12; // 12 in BCD is 0001 0010, but we use 4 bits to simplify
        minutes <= 6'd0;
        seconds <= 6'd0;
        pm <= 1'b0; // AM
    end
    // Increment counters when ena is high
    else if (ena) begin
        if (seconds == 6'd59) begin
            seconds <= 6'd0;
            if (minutes == 6'd59) begin
                minutes <= 6'd0;
                if (hours == 4'd12) begin
                    hours <= 4'd1; // Wrap around to 1 AM
                    pm <= 1'b0; // AM
                end
                else if (hours == 4'd12 - 1) begin // 11 AM
                    hours <= 4'd12; // 12 PM
                    pm <= 1'b1; // PM
                end
                else if (hours >= 4'd12) begin // PM range
                    hours <= 4'd1; // Wrap around to 1 AM
                    pm <= 1'b0; // AM
                end
                else begin
                    hours <= hours + 1'b1;
                end
            end
            else begin
                minutes <= minutes + 1'b1;
            end
        end
        else begin
            seconds <= seconds + 1'b1;
        end
    end
end

// Convert internal counters to BCD outputs
always @(hours, minutes, seconds) begin
    hh <= {4'd0, hours}; // Pad with zeros for 8-bit output
    mm <= {2'd0, minutes[5:4], minutes[3:0]}; // Convert to BCD
    ss <= {2'd0, seconds[5:4], seconds[3:0]}; // Convert to BCD
end

endmodule