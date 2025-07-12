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
    end else if (Secs == 6'b111011) begin
        Secs <= 6'b0;
    end else begin
        Secs <= Secs + 1'b1;
    end
end

always @(posedge CLK or posedge RST) begin
    if (RST) begin
        Mins <= 6'b0;
    end else if (Secs == 6'b111011 && Mins == 6'b111011) begin
        Mins <= 6'b0;
    end else if (Secs == 6'b111011) begin
        Mins <= Mins + 1'b1;
    end else begin
        Mins <= Mins;
    end
end

always @(posedge CLK or posedge RST) begin
    if (RST) begin
        Hours <= 6'b0;
    end else if (Mins == 6'b111011 && Secs == 6'b111011 && Hours == 6'b010011) begin
        Hours <= 6'b0;
    end else if (Mins == 6'b111011 && Secs == 6'b111011) begin
        Hours <= Hours + 1'b1;
    end else begin
        Hours <= Hours;
    end
end

endmodule