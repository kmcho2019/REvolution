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
        if (Secs == 0) begin
            Mins <= (Mins == 59) ? 0 : Mins + 1;
            if (Mins == 0 && Secs == 0) begin
                Hours <= (Hours == 23) ? 0 : Hours + 1;
            end
        end
    end
end

endmodule