module calendar(
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
        if (Secs == 6'd0) begin
            Mins <= (Mins == 6'd59)? 6'd0 : Mins + 1'd1;
            if (Mins == 6'd0) begin
                Hours <= (Hours == 5'd23)? 5'd0 : Hours + 1'd1;
            end else begin
                Hours <= Hours;
            end
        end else begin
            Mins <= Mins;
            Hours <= Hours;
        end
    end
end

endmodule