module calendar (
    input  wire CLK,
    input  wire RST,
    output reg [5:0] Hours,
    output reg [5:0] Mins,
    output reg [5:0] Secs
);

always @(posedge CLK or posedge RST) begin
    if (RST) begin
        Secs  <= 6'd0;
        Mins  <= 6'd0;
        Hours <= 6'd0;
    end else if (Secs == 6'd59) begin
        Secs <= 6'd0;
        if (Mins == 6'd59) begin
            Mins <= 6'd0;
            Hours <= (Hours == 6'd23) ? 6'd0 : Hours + 6'd1;
        end else begin
            Mins <= Mins + 6'd1;
        end
    end else begin
        Secs <= Secs + 6'd1;
    end
end

endmodule