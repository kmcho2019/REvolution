module calendar(
    input CLK, 
    input RST, 
    output reg [5:0] Secs, 
    output reg [5:0] Mins, 
    output reg [4:0] Hours
);

always @(posedge CLK or posedge RST) begin
    if (RST) begin
        Secs <= 6'b0;
    end else begin
        Secs <= (Secs == 6'd59) ? 6'b0 : Secs + 1'b1;
    end
end

always @(posedge CLK or posedge RST) begin
    if (RST) begin
        Mins <= 6'b0;
    end else begin
        Mins <= (Secs == 6'd59) ? (Mins == 6'd59) ? 6'b0 : Mins + 1'b1 : Mins;
    end
end

always @(posedge CLK or posedge RST) begin
    if (RST) begin
        Hours <= 5'b0;
    end else begin
        Hours <= (Mins == 6'd59 && Secs == 6'd59) ? (Hours == 5'd23) ? 5'b0 : Hours + 1'b1 : Hours;
    end
end

endmodule