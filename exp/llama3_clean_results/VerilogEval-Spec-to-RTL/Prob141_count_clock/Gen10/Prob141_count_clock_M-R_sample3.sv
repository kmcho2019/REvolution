module TopModule(
    input clk,
    input reset,
    input ena,
    output reg pm,
    output reg [7:0] hh,
    output reg [7:0] mm,
    output reg [7:0] ss
);

reg [5:0] seconds;
reg [5:0] minutes;
reg [4:0] hours;

always @(posedge clk) begin
    if (reset) begin
        seconds <= 6'd0;
        minutes <= 6'd0;
        hours <= 5'd0;
        pm <= 1'b0;
    end else if (ena) begin
        // Increment seconds
        if (seconds == 6'd59) begin
            seconds <= 6'd0;
            // Increment minutes
            if (minutes == 6'd59) begin
                minutes <= 6'd0;
                // Increment hours
                if (hours == 5'd11) begin
                    hours <= 5'd0;
                    pm <= ~pm; // Toggle AM/PM
                end else if (hours == 5'd12) begin
                    hours <= 5'd1;
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

// Convert binary to BCD
assign hh = (hours < 5'd10) ? {4'h0, hours} : {4'h1, hours - 5'd10};
assign mm = (minutes < 6'd10) ? {4'h0, minutes} : {4'h1, minutes - 6'd10};
assign ss = (seconds < 6'd10) ? {4'h0, seconds} : {4'h1, seconds - 6'd10};

endmodule