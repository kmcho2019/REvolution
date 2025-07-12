module calendar(
    input CLK, // Clock input
    input RST, // Active high reset signal
    output reg [5:0] Secs, // 6-bit output representing the current seconds
    output reg [5:0] Mins, // 6-bit output representing the current minutes
    output reg [4:0] Hours // 5-bit output representing the current hours
    );

always @ (posedge CLK or posedge RST) begin
    if (RST) begin
        Secs <= 0;
    end else if (Secs == 6'd59) begin
        Secs <= 0;
    end else begin
        Secs <= Secs + 1;
    end
end

always @ (posedge CLK or posedge RST) begin
    if (RST) begin
        Mins <= 0;
    end else if (Mins == 6'd59 && Secs == 6'd59) begin
        Mins <= 0;
    end else if (Secs == 6'd59) begin
        Mins <= Mins + 1;
    end else begin
        Mins <= Mins;
    end
end

always @ (posedge CLK or posedge RST) begin
    if (RST) begin
        Hours <= 0;
    end else if (Hours == 5'd23 && Mins == 6'd59 && Secs == 6'd59) begin
        Hours <= 0;
    end else if (Mins == 6'd59 && Secs == 6'd59) begin
        Hours <= Hours + 1;
    end else begin
        Hours <= Hours;
    end
end

endmodule