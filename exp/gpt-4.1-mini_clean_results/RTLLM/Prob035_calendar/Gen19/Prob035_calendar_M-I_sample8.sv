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

    // Clock enable signals
    wire secs_wrap = (Secs == 6'd59);
    wire mins_wrap = (Mins == 6'd59);

    // Update seconds every clock cycle or reset
    always @(posedge CLK or posedge RST) begin
        if (RST)
            Secs <= 6'd0;
        else
            Secs <= next_Secs;
    end

    // Update minutes only when seconds wrap or reset
    always @(posedge CLK or posedge RST) begin
        if (RST)
            Mins <= 6'd0;
        else if (secs_wrap)
            Mins <= next_Mins;
    end

    // Update hours only when minutes and seconds wrap or reset
    always @(posedge CLK or posedge RST) begin
        if (RST)
            Hours <= 5'd0;
        else if (secs_wrap && mins_wrap)
            Hours <= next_Hours;
    end

    // Combinational logic for next state calculation
    always @(*) begin
        // Seconds logic: wrap at 59
        if (Secs == 6'd59)
            next_Secs = 6'd0;
        else
            next_Secs = Secs + 6'd1;

        // Minutes logic: wrap at 59
        if (Mins == 6'd59)
            next_Mins = 6'd0;
        else
            next_Mins = Mins + 6'd1;

        // Hours logic: wrap at 23
        if (Hours == 5'd23)
            next_Hours = 5'd0;
        else
            next_Hours = Hours + 5'd1;
    end

endmodule