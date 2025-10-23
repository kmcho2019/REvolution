module calendar (
    input  wire       CLK,
    input  wire       RST,
    output reg  [4:0] Hours, // 0-23
    output reg  [5:0] Mins,  // 0-59
    output reg  [5:0] Secs   // 0-59
);

always @(posedge CLK or posedge RST) begin
    if (RST) begin
        Hours <= 5'd0;
        Mins  <= 6'd0;
        Secs  <= 6'd0;
    end else begin
        if (Secs == 6'd59) begin
            Secs <= 6'd0;
            // Increment minutes only when seconds roll over
            if (Mins == 6'd59) begin
                Mins <= 6'd0;
                // Increment hours only when minutes roll over
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
            // No change to Mins or Hours to reduce switching
            // Registers hold their previous values implicitly (no assignment)
        end
    end
end

endmodule