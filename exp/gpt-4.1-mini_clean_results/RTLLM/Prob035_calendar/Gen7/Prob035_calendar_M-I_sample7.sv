module calendar (
    input  wire       CLK,
    input  wire       RST,
    output reg  [5:0] Hours,  // 6 bits as requested (though 5 suffice)
    output reg  [5:0] Mins,
    output reg  [5:0] Secs
);

// Seconds counter
always @(posedge CLK or posedge RST) begin
    if (RST) begin
        Secs <= 6'd0;
    end else begin
        if (Secs == 6'd59) begin
            Secs <= 6'd0;
        end else begin
            Secs <= Secs + 6'd1;
        end
    end
end

// Minutes counter, incremented only when Secs wraps from 59 to 0
always @(posedge CLK or posedge RST) begin
    if (RST) begin
        Mins <= 6'd0;
    end else begin
        if (Secs == 6'd59) begin
            if (Mins == 6'd59) begin
                Mins <= 6'd0;
            end else begin
                Mins <= Mins + 6'd1;
            end
        end
        // else keep Mins unchanged
    end
end

// Hours counter, incremented only when Mins and Secs wrap from 59 to 0
always @(posedge CLK or posedge RST) begin
    if (RST) begin
        Hours <= 6'd0;
    end else begin
        if ((Mins == 6'd59) && (Secs == 6'd59)) begin
            if (Hours == 6'd23) begin
                Hours <= 6'd0;
            end else begin
                Hours <= Hours + 6'd1;
            end
        end
        // else keep Hours unchanged
    end
end

endmodule