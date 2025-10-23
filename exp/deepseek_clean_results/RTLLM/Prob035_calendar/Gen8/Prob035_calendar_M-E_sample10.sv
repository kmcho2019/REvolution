module calendar (
    input CLK,
    input RST,
    output reg [4:0] Hours,
    output reg [5:0] Mins,
    output reg [5:0] Secs
);

// Internal enable signals
wire sec_en = 1'b1;  // Always counting
wire min_en = (Secs == 6'd59);
wire hour_en = (Mins == 6'd59) & min_en;

always @(posedge CLK) begin
    if (RST) begin
        Secs <= 6'd0;
        Mins <= 6'd0;
        Hours <= 5'd0;
    end else begin
        // Second counter (always increments)
        if (sec_en) begin
            Secs <= (Secs == 6'd59) ? 6'd0 : Secs + 1;
        end

        // Minute counter (only when seconds roll over)
        if (min_en) begin
            Mins <= (Mins == 6'd59) ? 6'd0 : Mins + 1;
        end

        // Hour counter (only when minutes and seconds roll over)
        if (hour_en) begin
            Hours <= (Hours == 5'd23) ? 5'd0 : Hours + 1;
        end
    end
end

endmodule