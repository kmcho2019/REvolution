module calendar (
    input  wire       CLK,
    input  wire       RST,
    output reg  [4:0] Hours,  // 5 bits sufficient for 0-23
    output reg  [5:0] Mins,
    output reg  [5:0] Secs
);

always @(posedge CLK or posedge RST) begin
    if (RST) begin
        Hours <= 5'd0;
        Mins  <= 6'd0;
        Secs  <= 6'd0;
    end else begin
        if (Secs == 6'd59) begin
            Secs <= 6'd0;
            if (Mins == 6'd59) begin
                Mins <= 6'd0;
                if (Hours == 5'd23) begin
                    Hours <= 5'd0;
                end else begin
                    Hours <= Hours + 5'd1;
                end
            end else begin
                Mins <= Mins + 6'd1;
                Hours <= Hours;  // Hold Hours steady
            end
        end else begin
            Secs <= Secs + 6'd1;
            Mins <= Mins;      // Hold Mins steady
            Hours <= Hours;    // Hold Hours steady
        end
    end
end

endmodule