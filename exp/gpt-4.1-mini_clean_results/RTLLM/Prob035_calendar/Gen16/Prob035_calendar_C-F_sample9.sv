module calendar (
    input  wire       CLK,
    input  wire       RST,
    output reg  [4:0] Hours, // 0-23
    output reg  [5:0] Mins,  // 0-59
    output reg  [5:0] Secs   // 0-59
);

// Seconds counter: increments every clock cycle, resets to 0 when RST is high or reaches 59
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

// Minutes counter: increments only when seconds roll from 59 to 0; reset on RST
always @(posedge CLK or posedge RST) begin
    if (RST) begin
        Mins <= 6'd0;
    end else begin
        if (Secs == 6'd59) begin // increment minutes on next cycle after seconds reach 59
            if (Mins == 6'd59)
                Mins <= 6'd0;
            else
                Mins <= Mins + 6'd1;
        end
        // else hold current Mins value (implicit)
    end
end

// Hours counter: increments only when both minutes and seconds roll over from 59 to 0; reset on RST
always @(posedge CLK or posedge RST) begin
    if (RST) begin
        Hours <= 5'd0;
    end else begin
        if ((Mins == 6'd59) && (Secs == 6'd59)) begin
            if (Hours == 5'd23)
                Hours <= 5'd0;
            else
                Hours <= Hours + 5'd1;
        end
        // else hold current Hours value (implicit)
    end
end

endmodule