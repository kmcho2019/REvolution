module calendar (
    input  wire       CLK,
    input  wire       RST,
    output reg  [5:0] Secs,   // 0-59 needs 6 bits
    output reg  [5:0] Mins,   // 0-59 needs 6 bits
    output reg  [5:0] Hours   // 0-23 needs 5 bits, kept 6 bits as requested
);

// Seconds counter: increments every clock cycle or resets
always @(posedge CLK or posedge RST) begin
    if (RST) begin
        Secs <= 6'd0;
    end else if (Secs == 6'd59) begin
        Secs <= 6'd0;
    end else begin
        Secs <= Secs + 6'd1;
    end
end

// Minutes counter: increments when seconds roll over from 59 to 0
wire min_inc = (Secs == 6'd59);

always @(posedge CLK or posedge RST) begin
    if (RST) begin
        Mins <= 6'd0;
    end else if (min_inc) begin
        if (Mins == 6'd59) begin
            Mins <= 6'd0;
        end else begin
            Mins <= Mins + 6'd1;
        end
    end
    // else keep current minutes value
end

// Hours counter: increments when minutes roll over from 59 to 0 and seconds roll over from 59 to 0 simultaneously
wire hour_inc = (Mins == 6'd59) && (Secs == 6'd59);

always @(posedge CLK or posedge RST) begin
    if (RST) begin
        Hours <= 6'd0;
    end else if (hour_inc) begin
        if (Hours == 6'd23) begin
            Hours <= 6'd0;
        end else begin
            Hours <= Hours + 6'd1;
        end
    end
    // else keep current hours value
end

endmodule