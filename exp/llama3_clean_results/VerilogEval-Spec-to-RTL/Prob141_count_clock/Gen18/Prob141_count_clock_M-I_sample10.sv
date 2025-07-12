module TopModule (
    input clk,
    input reset,
    input ena,
    output pm,
    output [7:0] hh,
    output [7:0] mm,
    output [7:0] ss
);

    reg [3:0] hours;
    reg [5:0] minutes;
    reg [5:0] seconds;

    always @(posedge clk) begin
        if (reset) begin
            hours <= 1; // Reset to 12:00:00 AM
            minutes <= 0;
            seconds <= 0;
        end else if (ena) begin
            if (seconds == 59) begin
                seconds <= 0;
                if (minutes == 59) begin
                    minutes <= 0;
                    if (hours == 12) begin
                        hours <= 1;
                    end else begin
                        hours <= hours + 1;
                    end
                end else begin
                    minutes <= minutes + 1;
                end
            end else begin
                seconds <= seconds + 1;
            end
        end
    end

    // Derive the 'pm' output directly from the hours counter
    assign pm = (hours >= 7 && hours <= 12);

    // Assign outputs with correct BCD conversion
    // Directly assign the values to the output ports, ensuring proper alignment
    assign hh = {4'b0000, hours};
    assign mm = (minutes < 10) ? {6'b000000, minutes} : {4'b0000, minutes / 10, 4'b0000, minutes % 10};
    assign ss = (seconds < 10) ? {6'b000000, seconds} : {4'b0000, seconds / 10, 4'b0000, seconds % 10};

endmodule