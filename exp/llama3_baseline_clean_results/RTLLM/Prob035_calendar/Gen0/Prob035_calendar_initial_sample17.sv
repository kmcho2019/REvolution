module calendar(
    input CLK,
    input RST,
    output reg [5:0] Hours,
    output reg [5:0] Mins,
    output reg [5:0] Secs
);

always @(posedge CLK or posedge RST) begin
    if (RST) begin
        Secs <= 6'b0;
    end else if (Secs == 6'b111011) begin // 59 in binary
        Secs <= 6'b0;
    end else begin
        Secs <= Secs + 1'b1;
    end
end

always @(posedge CLK or posedge RST) begin
    if (RST) begin
        Mins <= 6'b0;
    end else if (Secs == 6'b111011 && Mins == 6'b111011) begin // 59 in binary
        Mins <= 6'b0;
    end else if (Secs == 6'b111011) begin // 59 in binary
        Mins <= Mins + 1'b1;
    end else begin
        Mins <= Mins;
    end
end

always @(posedge CLK or posedge RST) begin
    if (RST) begin
        Hours <= 6'b0;
    end else if (Secs == 6'b111011 && Mins == 6'b111011 && Hours == 6'b101111) begin // 23, 59, 59 in binary
        Hours <= 6'b0;
    end else if (Secs == 6'b111011 && Mins == 6'b111011) begin // 59, 59 in binary
        Hours <= Hours + 1'b1;
    end else begin
        Hours <= Hours;
    end
end

endmodule