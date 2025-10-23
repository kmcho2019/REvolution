module calendar (
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
        if (Secs == MAX_SEC) begin
            Secs <= 6'd0;
            
            // Minutes counter
            if (Mins == MAX_MIN) begin
                Mins <= 6'd0;
                
                // Hours counter
                if (Hours == MAX_HOUR) begin
                    Hours <= 6'd0;
                end else begin
                    Hours <= Hours + 6'd1;
                end
            end else begin
                Mins <= Mins + 6'd1;
            end
        end else begin
            Secs <= Secs + 6'd1;
        end
    end
end

endmodule