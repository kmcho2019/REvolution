module calendar (
    input CLK,
    input RST,
    output reg [5:0] Hours,
    output reg [5:0] Mins,
    output reg [5:0] Secs
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
    end else if (Secs == 59) begin
        Mins <= (Mins == 59) ? 0 : Mins + 1;
    end
end

always @(posedge CLK or posedge RST) begin
    if (RST) begin
        Hours <= 0;
    end else if (Secs == 59 && Mins == 59) begin
        Hours <= (Hours == 23) ? 0 : Hours + 1;
    end
end

endmodule