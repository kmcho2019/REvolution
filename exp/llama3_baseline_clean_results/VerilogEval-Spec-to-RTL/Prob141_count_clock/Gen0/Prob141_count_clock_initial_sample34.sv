module TopModule(
    input           clk,
    input           reset,
    input           ena,
    output          pm,
    output [7:0]    hh,
    output [7:0]    mm,
    output [7:0]    ss
);

reg [7:0] hours;
reg [7:0] minutes;
reg [7:0] seconds;
reg        isPM;

// Initialize counters
initial begin
    hours    = 8'h01;  // Initial hour is 1 (01 in BCD)
    minutes  = 8'h00;  // Initial minutes are 0 (00 in BCD)
    seconds  = 8'h00;  // Initial seconds are 0 (00 in BCD)
    isPM     = 1'b0;   // Initial state is AM
end

// Synchronous reset and enable logic
always @(posedge clk) begin
    if (reset) begin
        // Reset counters and state
        hours    <= 8'h01;
        minutes  <= 8'h00;
        seconds  <= 8'h00;
        isPM     <= 1'b0;
    end else if (ena) begin
        // Increment seconds
        if (seconds == 8'h59) begin
            seconds <= 8'h00;
            // Increment minutes
            if (minutes == 8'h59) begin
                minutes <= 8'h00;
                // Increment hours
                if (hours == 8'h12) begin
                    hours <= 8'h01;
                    isPM <= ~isPM;  // Toggle AM/PM
                end else if (hours == 8'h01 && isPM == 1'b0) begin
                    hours <= 8'h02;
                end else if (hours == 8'h12 && isPM == 1'b0) begin
                    hours <= 8'h01;
                    isPM <= 1'b1;  // Switch to PM
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

// Continuous assignments
assign hh = hours;
assign mm = minutes;
assign ss = seconds;
assign pm = isPM;

endmodule