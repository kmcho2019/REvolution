module calendar(
    input CLK,
    input RST,
    output reg [5:0] Hours,
    output reg [5:0] Mins,
    output reg [5:0] Secs
);

localparam MAX_SEC = 6'd59;
localparam MAX_MIN = 6'd59;
localparam MAX_HOUR = 6'd23;

always @(posedge CLK or posedge RST) begin
    if (RST) begin
        Secs <= 6'd0;
        Mins <= 6'd0;
        Hours <= 6'd0;
    end else begin
        // Seconds counter
        Secs <= (Secs == MAX_SEC) ? 6'd0 : Secs + 1;
        
        // Minutes counter - increments when seconds roll over
        if (Secs == MAX_SEC) begin
            Mins <= (Mins == MAX_MIN) ? 6'd0 : Mins + 1;
        end
        
        // Hours counter - increments when both minutes and seconds roll over
        if ((Secs == MAX_SEC) && (Mins == MAX_MIN)) begin
            Hours <= (Hours == MAX_HOUR) ? 6'd0 : Hours + 1;
        end
    end
end

endmodule