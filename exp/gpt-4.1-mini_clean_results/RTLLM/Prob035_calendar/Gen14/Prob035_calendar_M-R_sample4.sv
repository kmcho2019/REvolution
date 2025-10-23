module calendar (
    input  wire       CLK,
    input  wire       RST,
    output reg  [4:0] Hours, // 0-23
    output reg  [5:0] Mins,  // 0-59
    output reg  [5:0] Secs   // 0-59
);

// Seconds counter: increments every clock cycle, rolls over at 59
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

// Minutes counter: increments when seconds roll from 59 to 0
always @(posedge CLK or posedge RST) begin
    if (RST) begin
        Mins <= 6'd0;
    end else begin
        if (Secs == 6'd59) begin // on next clk, seconds reset, so increment mins
            if (Mins == 6'd59) begin
                Mins <= 6'd0;
            end else begin
                Mins <= Mins + 6'd1;
            end
        end
        // else hold Mins
    end
end

// Hours counter: increments when minutes roll from 59 to 0 and seconds are at 59 (about to roll)
always @(posedge CLK or posedge RST) begin
    if (RST) begin
        Hours <= 5'd0;
    end else begin
        if ((Mins == 6'd59) && (Secs == 6'd59)) begin
            if (Hours == 5'd23) begin
                Hours <= 5'd0;
            end else begin
                Hours <= Hours + 5'd1;
            end
        end
        // else hold Hours
    end
end

endmodule