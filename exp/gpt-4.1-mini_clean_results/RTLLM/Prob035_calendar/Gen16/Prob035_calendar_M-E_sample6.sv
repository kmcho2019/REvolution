module calendar (
    input  wire       CLK,
    input  wire       RST,
    output reg  [4:0] Hours,  // 0-23 fits in 5 bits
    output reg  [5:0] Mins,   // 0-59 fits in 6 bits
    output reg  [5:0] Secs    // 0-59 fits in 6 bits
);

always @(posedge CLK or posedge RST) begin
    if (RST) begin
        Secs  <= 6'd0;
        Mins  <= 6'd0;
        Hours <= 5'd0;
    end else begin
        // Increment seconds
        if (Secs == 6'd59) begin
            Secs <= 6'd0;
            // Increment minutes on seconds rollover
            if (Mins == 6'd59) begin
                Mins <= 6'd0;
                // Increment hours on minutes rollover
                if (Hours == 5'd23) begin
                    Hours <= 5'd0;
                end else begin
                    Hours <= Hours + 5'd1;
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