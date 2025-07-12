module calendar (
    input  wire       CLK,
    input  wire       RST,
    output reg  [4:0] Hours, // 0-23
    output reg  [5:0] Mins,  // 0-59
    output reg  [5:0] Secs   // 0-59
);

    // Next state signals for counters
    reg [5:0] next_Secs;
    reg [5:0] next_Mins;
    reg [4:0] next_Hours;

    always @(posedge CLK or posedge RST) begin
        if (RST) begin
            Hours <= 5'd0;
            Mins  <= 6'd0;
            Secs  <= 6'd0;
        end else begin
            Hours <= next_Hours;
            Mins  <= next_Mins;
            Secs  <= next_Secs;
        end
    end

    // Combinational logic for next state calculation
    always @(*) begin
        // Seconds logic: wrap at 59
        if (Secs == 6'd59)
            next_Secs = 6'd0;
        else
            next_Secs = Secs + 6'd1;

        // Minutes logic: increment when seconds wrap
        if ((Mins == 6'd59) && (Secs == 6'd59))
            next_Mins = 6'd0;
        else if (Secs == 6'd59)
            next_Mins = Mins + 6'd1;
        else
            next_Mins = Mins;

        // Hours logic: increment when minutes and seconds wrap
        if ((Hours == 5'd23) && (Mins == 6'd59) && (Secs == 6'd59))
            next_Hours = 5'd0;
        else if ((Mins == 6'd59) && (Secs == 6'd59))
            next_Hours = Hours + 5'd1;
        else
            next_Hours = Hours;
    end

endmodule