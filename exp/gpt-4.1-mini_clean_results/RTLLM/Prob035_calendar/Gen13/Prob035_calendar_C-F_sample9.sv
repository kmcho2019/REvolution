module calendar (
    input  wire       CLK,
    input  wire       RST,
    output reg  [5:0] Hours, // 0-23 zero-extended to 6 bits as per specification
    output reg  [5:0] Mins,  // 0-59
    output reg  [5:0] Secs   // 0-59
);

    // Internal narrower registers for hours (5 bits suffice)
    reg [4:0] hours_cnt;
    reg [5:0] mins_cnt;
    reg [5:0] secs_cnt;

    // Rollover flags for seconds and minutes to use as enables
    wire secs_rollover;
    wire mins_rollover;

    assign secs_rollover = (secs_cnt == 6'd59);
    assign mins_rollover = (mins_cnt == 6'd59);

    // Seconds counter: increments every clock, resets asynchronously
    always @(posedge CLK or posedge RST) begin
        if (RST) begin
            secs_cnt <= 6'd0;
        end else begin
            if (secs_rollover)
                secs_cnt <= 6'd0;
            else
                secs_cnt <= secs_cnt + 6'd1;
        end
    end

    // Minutes counter: increments on seconds rollover only
    always @(posedge CLK or posedge RST) begin
        if (RST) begin
            mins_cnt <= 6'd0;
        end else if (secs_rollover) begin
            if (mins_rollover)
                mins_cnt <= 6'd0;
            else
                mins_cnt <= mins_cnt + 6'd1;
        end
        // else no change
    end

    // Hours counter: increments on minutes and seconds rollover
    always @(posedge CLK or posedge RST) begin
        if (RST) begin
            hours_cnt <= 5'd0;
        end else if (mins_rollover && secs_rollover) begin
            if (hours_cnt == 5'd23)
                hours_cnt <= 5'd0;
            else
                hours_cnt <= hours_cnt + 5'd1;
        end
        // else no change
    end

    // Output assignments with zero-extension for Hours to 6 bits
    always @(*) begin
        Secs  = secs_cnt;
        Mins  = mins_cnt;
        Hours = {1'b0, hours_cnt}; // zero-extend from 5 to 6 bits
    end

endmodule