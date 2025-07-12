module calendar (
    input  wire       CLK,
    input  wire       RST,
    output reg [5:0]  Hours,
    output reg [5:0]  Mins,
    output reg [5:0]  Secs
);

// Signal indicating second rollover from 59 to 0
reg sec_rollover;
// Signal indicating minute rollover from 59 to 0
reg min_rollover;

// Seconds counter
always @(posedge CLK or posedge RST) begin
    if (RST) begin
        Secs <= 6'd0;
        sec_rollover <= 1'b0;
    end else begin
        if (Secs == 6'd59) begin
            Secs <= 6'd0;
            sec_rollover <= 1'b1;
        end else begin
            Secs <= Secs + 6'd1;
            sec_rollover <= 1'b0;
        end
    end
end

// Minutes counter
always @(posedge CLK or posedge RST) begin
    if (RST) begin
        Mins <= 6'd0;
        min_rollover <= 1'b0;
    end else begin
        if (sec_rollover) begin
            if (Mins == 6'd59) begin
                Mins <= 6'd0;
                min_rollover <= 1'b1;
            end else begin
                Mins <= Mins + 6'd1;
                min_rollover <= 1'b0;
            end
        end else begin
            // No change if seconds did not rollover
            Mins <= Mins;
            min_rollover <= 1'b0;
        end
    end
end

// Hours counter
always @(posedge CLK or posedge RST) begin
    if (RST) begin
        Hours <= 6'd0;
    end else begin
        if (min_rollover) begin
            if (Hours == 6'd23) begin
                Hours <= 6'd0;
            end else begin
                Hours <= Hours + 6'd1;
            end
        end else begin
            // No change if minutes did not rollover
            Hours <= Hours;
        end
    end
end

endmodule