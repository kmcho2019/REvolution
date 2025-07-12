module calendar(CLK, RST, Hours, Mins, Secs);
    input CLK, RST;
    output reg [5:0] Hours;
    output reg [5:0] Mins;
    output reg [5:0] Secs;

    always @ (posedge CLK or posedge RST) begin
        if (RST) begin
            Secs <= 6'd0;
            Mins <= 6'd0;
            Hours <= 6'd0;
        end else begin
            Secs <= (Secs == 6'd59) ? 6'd0 : Secs + 1;
            if (Secs == 6'd0) begin
                Mins <= (Mins == 6'd59) ? 6'd0 : Mins + 1;
            end else begin
                Mins <= Mins;
            end
            if (Mins == 6'd0 && Secs == 6'd0) begin
                Hours <= (Hours == 6'd23) ? 6'd0 : Hours + 1;
            end else begin
                Hours <= Hours;
            end
        end
    end
endmodule