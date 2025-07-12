module calendar (
    input CLK,
    input RST,
    output reg [5:0] Hours,
    output reg [5:0] Mins,
    output reg [5:0] Secs
);

always @(posedge CLK or posedge RST) begin
    if (RST) begin
        Hours <= 6'd0;
        Mins <= 6'd0;
        Secs <= 6'd0;
    end else begin
        // Update seconds
        Secs <= (Secs == 6'd59) ? 6'd0 : Secs + 6'd1;
        
        // Update minutes when seconds roll over
        if (Secs == 6'd59) begin
            Mins <= (Mins == 6'd59) ? 6'd0 : Mins + 6'd1;
            
            // Update hours when minutes and seconds roll over
            if (Mins == 6'd59) begin
                Hours <= (Hours == 6'd23) ? 6'd0 : Hours + 6'd1;
            end
        end
    end
end

endmodule