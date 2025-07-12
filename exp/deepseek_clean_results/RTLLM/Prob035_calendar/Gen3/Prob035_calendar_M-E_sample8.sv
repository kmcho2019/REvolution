module calendar (
    input CLK,
    input RST,
    output reg [5:0] Hours,
    output reg [5:0] Mins,
    output reg [5:0] Secs
);

// Rollover control signals
wire sec_roll = (Secs == 6'd59);
wire min_roll = (Mins == 6'd59) & sec_roll;
wire hour_roll = (Hours == 6'd23) & min_roll;

always @(posedge CLK or posedge RST) begin
    if (RST) begin
        // Synchronous reset
        Secs <= 6'd0;
        Mins <= 6'd0;
        Hours <= 6'd0;
    end else begin
        // Parallel updates with rollover handling
        Secs <= sec_roll ? 6'd0 : Secs + 6'd1;
        Mins <= sec_roll ? (min_roll ? 6'd0 : Mins + 6'd1) : Mins;
        Hours <= min_roll ? (hour_roll ? 6'd0 : Hours + 6'd1) : Hours;
    end
end

endmodule