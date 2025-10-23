module calendar (
    input CLK,
    input RST,
    output reg [5:0] Hours,  // 6 bits for 0-23 (matches other outputs)
    output reg [5:0] Mins,
    output reg [5:0] Secs
);

// Parameterized constants
parameter SEC_MAX = 6'd59;
parameter MIN_MAX = 6'd59;
parameter HOUR_MAX = 6'd23;

always @(posedge CLK or posedge RST) begin
    if (RST) begin
        Hours <= 6'd0;
        Mins <= 6'd0;
        Secs <= 6'd0;
    end
    else begin
        // Seconds logic
        if (Secs == SEC_MAX) begin
            Secs <= 6'd0;
            // Minutes logic
            if (Mins == MIN_MAX) begin
                Mins <= 6'd0;
                // Hours logic
                if (Hours == HOUR_MAX)
                    Hours <= 6'd0;
                else
                    Hours <= Hours + 6'd1;
            end
            else
                Mins <= Mins + 6'd1;
        end
        else
            Secs <= Secs + 6'd1;
    end
end

endmodule