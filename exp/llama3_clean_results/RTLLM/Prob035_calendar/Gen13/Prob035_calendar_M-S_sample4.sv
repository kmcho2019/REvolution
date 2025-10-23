module calendar(
    input CLK, 
    input RST, 
    output reg [5:0] Secs, 
    output reg [5:0] Mins, 
    output reg [4:0] Hours
);

always @(posedge CLK or posedge RST) begin
    if (RST) begin
        Secs <= 0;
        Mins <= 0;
        Hours <= 0;
    end else begin
        Secs <= (Secs == 59) ? 0 : Secs + 1;
        Mins <= (Secs == 0 && Mins == 59) ? 0 : (Secs == 0 ? Mins + 1 : Mins);
        Hours <= (Mins == 0 && Secs == 0 && Hours == 23) ? 0 : (Mins == 0 && Secs == 0 ? Hours + 1 : Hours);
    end
end

endmodule