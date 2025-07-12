module calendar (
    input  wire       CLK,
    input  wire       RST,
    output reg [5:0]  Hours,
    output reg [5:0]  Mins,
    output reg [5:0]  Secs
);

// Seconds counter always block
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

// Minutes counter always block
always @(posedge CLK or posedge RST) begin
    if (RST) begin
        Mins <= 6'd0;
    end else begin
        // Increment minutes when seconds roll from 59 to 0
        if ((Secs == 6'd59))
            if (Mins == 6'd59)
                Mins <= 6'd0;
            else
                Mins <= Mins + 6'd1;
        else
            Mins <= Mins; // hold steady
    end
end

// Hours counter always block
always @(posedge CLK or posedge RST) begin
    if (RST) begin
        Hours <= 6'd0;
    end else begin
        // Increment hours when minutes and seconds roll over from 59 to 0
        if ((Mins == 6'd59) && (Secs == 6'd59)) begin
            if (Hours == 6'd23)
                Hours <= 6'd0;
            else
                Hours <= Hours + 6'd1;
        end else begin
            Hours <= Hours; // hold steady
        end
    end
end

endmodule