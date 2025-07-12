module TopModule(
    input  clk,    // clock signal
    input  reset,  // reset signal
    input  ena,    // enable signal
    output pm,     // pm/am indicator
    output [7:0] hh,  // hours in BCD format
    output [7:0] mm,  // minutes in BCD format
    output [7:0] ss   // seconds in BCD format
);

// internal counters
reg [7:0] seconds;
reg [7:0] minutes;
reg [7:0] hours;

// internal pm signal
reg pm_int;

// initialize counters and pm signal
initial begin
    seconds = 8'b00000000;  // 00 in BCD
    minutes = 8'b00000000;  // 00 in BCD
    hours = 8'b00010010;   // 12 in BCD
    pm_int = 1'b0;         // AM
end

// update counters and pm signal on positive edge of clock
always @(posedge clk) begin
    if (reset) begin
        // reset counters and pm signal on reset
        seconds <= 8'b00000000;  // 00 in BCD
        minutes <= 8'b00000000;  // 00 in BCD
        hours <= 8'b00010010;   // 12 in BCD
        pm_int <= 1'b0;         // AM
    end else if (ena) begin
        // increment counters
        if (seconds == 8'b01011001) begin  // 59 in BCD
            seconds <= 8'b00000000;  // 00 in BCD
            if (minutes == 8'b01011001) begin  // 59 in BCD
                minutes <= 8'b00000000;  // 00 in BCD
                if (hours == 8'b00010010) begin  // 12 in BCD
                    hours <= 8'b00010011;  // 01 in BCD
                    pm_int <= 1'b1;       // PM
                end else if (hours == 8'b00100100) begin  // 12 in BCD (PM)
                    hours <= 8'b00010010;  // 01 in BCD (AM)
                    pm_int <= 1'b0;       // AM
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

// assign outputs
assign pm = pm_int;
assign hh = hours;
assign mm = minutes;
assign ss = seconds;

endmodule