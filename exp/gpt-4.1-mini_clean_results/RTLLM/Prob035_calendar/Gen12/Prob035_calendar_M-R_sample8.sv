module calendar (
    input  wire       CLK,
    input  wire       RST,
    output reg  [5:0] Secs,  // 0-59
    output reg  [5:0] Mins,  // 0-59
    output reg  [5:0] Hours  // 0-23 stored in 6 bits for alignment
);

    // Next state signals
    reg [5:0] next_secs;
    reg [5:0] next_mins;
    reg [5:0] next_hours;

    always @(*) begin
        // Default next values keep current state
        next_secs  = Secs;
        next_mins  = Mins;
        next_hours = Hours;

        // Increment seconds and wrap
        if (Secs == 6'd59) begin
            next_secs = 6'd0;
            // Increment minutes on seconds wrap
            if (Mins == 6'd59) begin
                next_mins = 6'd0;
                // Increment hours on minutes and seconds wrap
                if (Hours == 6'd23)
                    next_hours = 6'd0;
                else
                    next_hours = Hours + 6'd1;
            end else begin
                next_mins = Mins + 6'd1;
            end
        end else begin
            next_secs = Secs + 6'd1;
        end
    end

    always @(posedge CLK or posedge RST) begin
        if (RST) begin
            Secs  <= 6'd0;
            Mins  <= 6'd0;
            Hours <= 6'd0;
        end else begin
            Secs  <= next_secs;
            Mins  <= next_mins;
            Hours <= next_hours;
        end
    end

endmodule