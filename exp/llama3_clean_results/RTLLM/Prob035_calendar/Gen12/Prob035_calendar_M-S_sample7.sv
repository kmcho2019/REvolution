module calendar (
    input CLK,
    input RST,
    output reg [5:0] Secs,
    output reg [5:0] Mins,
    output reg [4:0] Hours
);

always @(posedge CLK or posedge RST) begin
    if (RST) begin
        Secs <= 6'd0;
        Mins <= 6'd0;
        Hours <= 5'd0;
    end else begin
        Secs <= (Secs == 6'd59)? 6'd0 : Secs + 1'd1;
        Mins <= (Secs == 6'd0 && Mins == 6'd59)? 6'd0 : (Secs == 6'd0)? Mins + 1'd1 : Mins;
        Hours <= (Secs == 6'd0 && Mins == 6'd0 && Hours == 5'd23)? 5'd0 : (Secs == 6'd0 && Mins == 6'd0)? Hours + 1'd1 : Hours;
    end
end

endmodule