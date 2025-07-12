module calendar (
    input  wire       CLK,
    input  wire       RST,
    output reg  [5:0] Hours, // 0-23, but 6 bits per spec
    output reg  [5:0] Mins,  // 0-59
    output reg  [5:0] Secs   // 0-59
);

// Seconds counter
always @(posedge CLK or posedge RST) begin
    if (RST) begin
        Secs <= 6'd0;
    end else begin
        if (Secs == 6'd59)
            Secs <= 6'd0;
        else
            Secs <= Secs + 6'd1;
    end
end

// Minutes counter: increment when seconds roll over from 59 to 0
always @(posedge CLK or posedge RST) begin
    if (RST) begin
        Mins <= 6'd0;
    end else if (Secs == 6'd59) begin
        if (Mins == 6'd59)
            Mins <= 6'd0;
        else
            Mins <= Mins + 6'd1;
    end
    // else retain current Mins value
end

// Hours counter: increment when minutes and seconds both roll over from 59 to 0
always @(posedge CLK or posedge RST) begin
    if (RST) begin
        Hours <= 6'd0;
    end else if (Mins == 6'd59 && Secs == 6'd59) begin
        if (Hours == 6'd23)
            Hours <= 6'd0;
        else
            Hours <= Hours + 6'd1;
    end
    // else retain current Hours value
end

endmodule