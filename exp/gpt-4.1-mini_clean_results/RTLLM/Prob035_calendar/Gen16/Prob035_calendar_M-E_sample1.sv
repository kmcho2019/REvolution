module calendar (
    input  wire       CLK,
    input  wire       RST,
    output reg  [5:0] Hours,  // Using 6 bits as per problem statement
    output reg  [5:0] Mins,
    output reg  [5:0] Secs
);

    // Internal signals to indicate rollovers
    reg sec_rollover;
    reg min_rollover;

    // Seconds counter: increments every clock cycle, rolls over at 59
    always @(posedge CLK or posedge RST) begin
        if (RST) begin
            Secs <= 6'd0;
            sec_rollover <= 1'b0;
        end else begin
            if (Secs == 6'd59) begin
                Secs <= 6'd0;
                sec_rollover <= 1'b1;
            end else begin
                Secs <= Secs + 6'd1;
                sec_rollover <= 1'b0;
            end
        end
    end

    // Minutes counter: increments when seconds rollover, rolls over at 59
    always @(posedge CLK or posedge RST) begin
        if (RST) begin
            Mins <= 6'd0;
            min_rollover <= 1'b0;
        end else if (sec_rollover) begin
            if (Mins == 6'd59) begin
                Mins <= 6'd0;
                min_rollover <= 1'b1;
            end else begin
                Mins <= Mins + 6'd1;
                min_rollover <= 1'b0;
            end
        end else begin
            // Hold value and no rollover signal if no sec rollover
            min_rollover <= 1'b0;
        end
    end

    // Hours counter: increments when minutes rollover, rolls over at 23
    always @(posedge CLK or posedge RST) begin
        if (RST) begin
            Hours <= 6'd0;
        end else if (min_rollover) begin
            if (Hours == 6'd23) begin
                Hours <= 6'd0;
            end else begin
                Hours <= Hours + 6'd1;
            end
        end
        // Else hold the current hours value
    end

endmodule