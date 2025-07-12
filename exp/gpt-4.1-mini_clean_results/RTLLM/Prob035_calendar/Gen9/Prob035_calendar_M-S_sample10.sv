module calendar (
    input  wire       CLK,
    input  wire       RST,
    output reg [5:0]  Hours,
    output reg [5:0]  Mins,
    output reg [5:0]  Secs
);

always @(posedge CLK or posedge RST) begin
    if (RST) begin
        Hours <= 6'd0;
        Mins  <= 6'd0;
        Secs  <= 6'd0;
    end else begin
        Secs <= (Secs == 6'd59) ? 6'd0 : Secs + 6'd1;
        Mins <= (Secs == 6'd59) ? ((Mins == 6'd59) ? 6'd0 : Mins + 6'd1) : Mins;
        Hours <= (Secs == 6'd59 && Mins == 6'd59) ? ((Hours == 6'd23) ? 6'd0 : Hours + 6'd1) : Hours;
    end
end

endmodule