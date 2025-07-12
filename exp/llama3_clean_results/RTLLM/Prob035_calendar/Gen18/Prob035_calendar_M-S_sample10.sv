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
    end else begin
        Secs <= (Secs == 59) ? 0 : Secs + 1;
    end
end

always @(posedge CLK or posedge RST) begin
    if (RST) begin
        Mins <= 0;
    end else begin
        Mins <= (Secs == 59) ? (Mins == 59) ? 0 : Mins + 1 : Mins;
    end
end

always @(posedge CLK or posedge RST) begin
    if (RST) begin
        Hours <= 0;
    end else begin
        Hours <= (Mins == 59 && Secs == 59) ? (Hours == 23) ? 0 : Hours + 1 : Hours;
    end
end

endmodule