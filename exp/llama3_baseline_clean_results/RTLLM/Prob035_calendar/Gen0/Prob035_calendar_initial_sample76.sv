module calendar(
    input CLK,        // Clock input
    input RST,        // Active high reset signal
    output reg [5:0] Hours,    // 6-bit output representing the current hours
    output reg [5:0] Mins,    // 6-bit output representing the current minutes
    output reg [5:0] Secs     // 6-bit output representing the current seconds
);

always @(posedge CLK or posedge RST) begin
    if (RST) begin
        Secs <= 6'd0;
    end else if (Secs == 6'd59) begin
        Secs <= 6'd0;
    end else begin
        Secs <= Secs + 1'd1;
    end
end

always @(posedge CLK or posedge RST) begin
    if (RST) begin
        Mins <= 6'd0;
    end else if (Mins == 6'd59 && Secs == 6'd59) begin
        Mins <= 6'd0;
    end else if (Secs == 6'd59) begin
        Mins <= Mins + 1'd1;
    end
end

always @(posedge CLK or posedge RST) begin
    if (RST) begin
        Hours <= 6'd0;
    end else if (Hours == 6'd23 && Mins == 6'd59 && Secs == 6'd59) begin
        Hours <= 6'd0;
    end else if (Mins == 6'd59 && Secs == 6'd59) begin
        Hours <= Hours + 1'd1;
    end
end

endmodule