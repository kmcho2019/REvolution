module calendar (
    input  wire       CLK,
    input  wire       RST,
    output reg  [5:0] Hours,
    output reg  [5:0] Mins,
    output reg  [5:0] Secs
);

// Flag to indicate seconds rollover
reg secs_rollover;
// Flag to indicate minutes rollover
reg mins_rollover;

// Seconds counter block
always @(posedge CLK or posedge RST) begin
    if (RST) begin
        Secs <= 6'd0;
        secs_rollover <= 1'b0;
    end else begin
        if (Secs == 6'd59) begin
            Secs <= 6'd0;
            secs_rollover <= 1'b1;
        end else begin
            Secs <= Secs + 6'd1;
            secs_rollover <= 1'b0;
        end
    end
end

// Minutes counter block
always @(posedge CLK or posedge RST) begin
    if (RST) begin
        Mins <= 6'd0;
        mins_rollover <= 1'b0;
    end else begin
        if (secs_rollover) begin
            if (Mins == 6'd59) begin
                Mins <= 6'd0;
                mins_rollover <= 1'b1;
            end else begin
                Mins <= Mins + 6'd1;
                mins_rollover <= 1'b0;
            end
        end else begin
            mins_rollover <= 1'b0;
        end
    end
end

// Hours counter block
always @(posedge CLK or posedge RST) begin
    if (RST) begin
        Hours <= 6'd0;
    end else begin
        if (mins_rollover) begin
            if (Hours == 6'd23) begin
                Hours <= 6'd0;
            end else begin
                Hours <= Hours + 6'd1;
            end
        end
    end
end

endmodule