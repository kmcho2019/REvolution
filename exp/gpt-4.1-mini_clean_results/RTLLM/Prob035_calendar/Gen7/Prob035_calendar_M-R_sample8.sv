module calendar (
    input  wire       CLK,
    input  wire       RST,
    output reg  [5:0] Secs,
    output reg  [5:0] Mins,
    output reg  [5:0] Hours
);

    wire secs_rollover;
    wire mins_rollover;

    // Seconds counter: increments every clock, resets to 0 at 59
    always @(posedge CLK or posedge RST) begin
        if (RST) begin
            Secs <= 6'd0;
        end else if (Secs == 6'd59) begin
            Secs <= 6'd0;
        end else begin
            Secs <= Secs + 6'd1;
        end
    end

    assign secs_rollover = (Secs == 6'd59);

    // Minutes counter: increments when seconds rollover
    always @(posedge CLK or posedge RST) begin
        if (RST) begin
            Mins <= 6'd0;
        end else if (secs_rollover) begin
            if (Mins == 6'd59) begin
                Mins <= 6'd0;
            end else begin
                Mins <= Mins + 6'd1;
            end
        end
    end

    assign mins_rollover = (Mins == 6'd59) & secs_rollover;

    // Hours counter: increments when minutes rollover (and seconds rollover)
    always @(posedge CLK or posedge RST) begin
        if (RST) begin
            Hours <= 6'd0;
        end else if (mins_rollover) begin
            if (Hours == 6'd23) begin
                Hours <= 6'd0;
            end else begin
                Hours <= Hours + 6'd1;
            end
        end
    end

endmodule