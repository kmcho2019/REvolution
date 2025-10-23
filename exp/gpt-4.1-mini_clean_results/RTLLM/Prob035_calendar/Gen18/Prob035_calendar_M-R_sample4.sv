module calendar (
    input  wire       CLK,
    input  wire       RST,
    output reg  [5:0] Secs,  // 0-59 range
    output reg  [5:0] Mins,  // 0-59 range
    output reg  [4:0] Hours  // 0-23 range
);

    // Next state signals (combinational)
    wire [5:0] next_secs;
    wire [5:0] next_mins;
    wire [4:0] next_hours;

    // Compute next seconds: increment or rollover to 0 at 59
    assign next_secs = (Secs == 6'd59) ? 6'd0 : Secs + 6'd1;

    // Compute if minute should increment (when seconds roll over)
    wire increment_min = (Secs == 6'd59);

    // Compute next minutes: increment or rollover to 0 at 59
    assign next_mins = increment_min ? ((Mins == 6'd59) ? 6'd0 : Mins + 6'd1) : Mins;

    // Compute if hour should increment (when minutes and seconds roll over)
    wire increment_hour = increment_min && (Mins == 6'd59);

    // Compute next hours: increment or rollover to 0 at 23
    assign next_hours = increment_hour ? ((Hours == 5'd23) ? 5'd0 : Hours + 5'd1) : Hours;

    // Sequential block: update registers synchronously with active high reset
    always @(posedge CLK) begin
        if (RST) begin
            Secs  <= 6'd0;
            Mins  <= 6'd0;
            Hours <= 5'd0;
        end else begin
            Secs  <= next_secs;
            Mins  <= next_mins;
            Hours <= next_hours;
        end
    end

endmodule