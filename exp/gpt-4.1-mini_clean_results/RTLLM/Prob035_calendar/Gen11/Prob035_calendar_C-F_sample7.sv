module calendar (
    input  wire       CLK,
    input  wire       RST,
    output reg  [4:0] Hours, // 0-23 requires 5 bits
    output reg  [5:0] Mins,  // 0-59
    output reg  [5:0] Secs   // 0-59
);

// Seconds and Minutes combined counter block
always @(posedge CLK or posedge RST) begin
    if (RST) begin
        Secs <= 6'd0;
        Mins <= 6'd0;
    end else begin
        if (Secs == 6'd59) begin
            Secs <= 6'd0;
            if (Mins == 6'd59) begin
                Mins <= 6'd0;
            end else begin
                Mins <= Mins + 6'd1;
            end
        end else begin
            Secs <= Secs + 6'd1;
            // Mins hold steady when seconds increment without wrapping
            Mins <= Mins;
        end
    end
end

// Hours counter block
always @(posedge CLK or posedge RST) begin
    if (RST) begin
        Hours <= 5'd0;
    end else begin
        // Increment hours only when minutes and seconds both wrap from 59 to 0 in next cycle
        if (Mins == 6'd59 && Secs == 6'd59) begin
            if (Hours == 5'd23) begin
                Hours <= 5'd0;
            end else begin
                Hours <= Hours + 5'd1;
            end
        end else begin
            Hours <= Hours;
        end
    end
end

endmodule