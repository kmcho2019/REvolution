module calendar(
    input CLK,
    input RST,
    output reg [5:0] Secs,
    output reg [5:0] Mins,
    output reg [4:0] Hours
);

reg [5:0] next_Secs;
reg [5:0] next_Mins;
reg [4:0] next_Hours;

assign next_Secs = (RST || Secs == 6'd59) ? 6'd0 : Secs + 6'd1;
assign next_Mins = (RST || (Mins == 6'd59 && Secs == 6'd59)) ? 6'd0 : (Secs == 6'd59) ? Mins + 6'd1 : Mins;
assign next_Hours = (RST || (Hours == 5'd23 && Mins == 6'd59 && Secs == 6'd59)) ? 5'd0 : (Mins == 6'd59 && Secs == 6'd59) ? Hours + 5'd1 : Hours;

always @(posedge CLK or posedge RST) begin
    if (RST) begin
        Secs <= 6'd0;
        Mins <= 6'd0;
        Hours <= 5'd0;
    end else begin
        Secs <= next_Secs;
        Mins <= next_Mins;
        Hours <= next_Hours;
    end
end

endmodule