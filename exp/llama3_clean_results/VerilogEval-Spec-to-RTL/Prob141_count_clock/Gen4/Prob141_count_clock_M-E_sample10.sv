module TopModule(
    input clk,
    input reset,
    input ena,
    output reg pm,
    output reg [7:0] hh,
    output reg [7:0] mm,
    output reg [7:0] ss
);

reg [5:0] state_seconds;
reg [5:0] state_minutes;
reg [3:0] state_hours;
reg am_pm;

always @(posedge clk) begin
    if (reset) begin
        state_seconds <= 6'd0;
        state_minutes <= 6'd0;
        state_hours <= 4'd0;
        am_pm <= 1'b0;
    end else if (ena) begin
        // Increment seconds
        if (state_seconds == 6'd59) begin
            state_seconds <= 6'd0;
            // Increment minutes
            if (state_minutes == 6'd59) begin
                state_minutes <= 6'd0;
                // Increment hours
                if (state_hours == 4'd11) begin
                    state_hours <= 4'd0;
                    am_pm <= 1'b0;
                end else begin
                    state_hours <= state_hours + 1'b1;
                    if (state_hours == 4'd12) begin
                        state_hours <= 4'd0;
                        am_pm <= 1'b0;
                    end else if (state_hours == 4'd6) begin
                        am_pm <= 1'b1;
                    end else if (state_hours == 4'd0 && am_pm == 1'b1) begin
                        am_pm <= 1'b0;
                    end
                end
            end else begin
                state_minutes <= state_minutes + 1'b1;
            end
        end else begin
            state_seconds <= state_seconds + 1'b1;
        end
    end
end

// Output logic
always @(posedge clk) begin
    if (reset) begin
        hh <= 8'd12;
        mm <= 8'd0;
        ss <= 8'd0;
        pm <= 1'b0;
    end else begin
        ss <= {2'b0, state_seconds};
        mm <= {2'b0, state_minutes};
        if (state_hours == 4'd0) begin
            hh <= 8'd12;
        end else begin
            hh <= {4'b0, state_hours};
        end
        pm <= am_pm;
    end
end

endmodule