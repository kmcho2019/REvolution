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
        Mins <= 6'b0;
        Hours <= 5'b0;
    end else begin
        Secs <= (Secs == 6'd59) ? 6'b0 : Secs + 1'b1;
        if (Secs == 6'd0) begin
            Mins <= (Mins == 6'd59) ? 6'b0 : Mins + 1'b1;
            if (Mins == 6'd0 && Secs == 6'd0) begin
                Hours <= (Hours == 5'd23) ? 5'b0 : Hours + 1'b1;
            end
        end
    end
end

endmodule