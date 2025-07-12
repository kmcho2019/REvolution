module calendar (
    input  wire       CLK,
    input  wire       RST,
    output reg  [5:0] Hours, // 0-23, stored in 6 bits as per spec
    output reg  [5:0] Mins,  // 0-59
    output reg  [5:0] Secs   // 0-59
);

always @(posedge CLK or posedge RST) begin
    if (RST) begin
        Secs  <= 6'd0;
        Mins  <= 6'd0;
        Hours <= 6'd0;
    end else begin
        // Increment seconds
        if (Secs == 6'd59) begin
            Secs <= 6'd0;
            // Increment minutes when seconds wrap
            if (Mins == 6'd59) begin
                Mins <= 6'd0;
                // Increment hours when minutes wrap
                if (Hours == 6'd23)
                    Hours <= 6'd0;
                else
                    Hours <= Hours + 6'd1;
            end else begin
                Mins <= Mins + 6'd1;
            end
        end else begin
            Secs <= Secs + 6'd1;
            // Minutes and hours unchanged
        end
    end
end

endmodule