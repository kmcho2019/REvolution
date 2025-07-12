module calendar (
    input CLK,
    input RST,
    output reg [5:0] Secs,
    output reg [5:0] Mins,
    output reg [4:0] Hours
);

always @(posedge CLK or posedge RST) begin
    if (RST) begin
        Secs <= 6'b0;
    end else if (Secs == 6'b111011) begin // 59 in binary
        Secs <= 6'b0;
    end else begin
        Secs <= Secs + 1;
    end
end

always @(posedge CLK or posedge RST) begin
    if (RST) begin
        Mins <= 6'b0;
    end else if (Secs == 6'b111011 && Mins == 6'b111011) begin // 59 in binary
        Mins <= 6'b0;
    end else if (Secs == 6'b111011) begin // 59 in binary
        Mins <= Mins + 1;
    end else begin
        Mins <= Mins;
    end
end

always @(posedge CLK or posedge RST) begin
    if (RST) begin
        Hours <= 5'b0;
    end else if (Secs == 6'b111011 && Mins == 6'b111011 && Hours == 5'b10111) begin // 59 and 23 in binary
        Hours <= 5'b0;
    end else if (Secs == 6'b111011 && Mins == 6'b111011) begin // 59 in binary
        Hours <= Hours + 1;
    end else begin
        Hours <= Hours;
    end
end

endmodule