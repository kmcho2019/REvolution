module calendar(
    input CLK,
    input RST,
    output reg [5:0] Secs,
    output reg [5:0] Mins,
    output reg [4:0] Hours
);

always @(posedge CLK or posedge RST) begin
    if (RST) Secs <= 0;
    else if (Secs == 59) Secs <= 0;
    else Secs <= Secs + 1;
end

always @(posedge CLK or posedge RST) begin
    if (RST) Mins <= 0;
    else if (Secs == 59) begin
        if (Mins == 59) Mins <= 0;
        else Mins <= Mins + 1;
    end
end

always @(posedge CLK or posedge RST) begin
    if (RST) Hours <= 0;
    else if (Secs == 59 && Mins == 59) begin
        if (Hours == 23) Hours <= 0;
        else Hours <= Hours + 1;
    end
end

endmodule