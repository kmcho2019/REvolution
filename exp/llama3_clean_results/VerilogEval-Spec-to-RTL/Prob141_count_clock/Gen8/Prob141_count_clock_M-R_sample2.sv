module TopModule(
    input clk,
    input reset,
    input ena,
    output reg pm,
    output reg [7:0] hh,
    output reg [7:0] mm,
    output reg [7:0] ss
);

reg [3:0] hours;
reg [5:0] minutes;
reg [5:0] seconds;

always @(posedge clk) begin
    if (reset) begin
        hours <= 4'd0; // Set hours to 0
        minutes <= 6'd0; // Set minutes to 0
        seconds <= 6'd0; // Set seconds to 0
        pm <= 1'b0; // Set pm to 0
    end else if (ena) begin
        // Increment seconds
        if (seconds == 6'd59) begin
            seconds <= 6'd0;
            // Increment minutes
            if (minutes == 6'd59) begin
                minutes <= 6'd0;
                // Increment hours
                if (hours == 4'd11) begin
                    hours <= 4'd0;
                    pm <= ~pm;
                end else begin
                    hours <= hours + 1'b1;
                end
            end else begin
                minutes <= minutes + 1'b1;
            end
        end else begin
            seconds <= seconds + 1'b1;
        end
    end
end

// Output logic using assign
assign hh = (hours == 4'd0)? 8'd12 : {4'b0, hours};
assign mm = {2'b0, minutes};
assign ss = {2'b0, seconds};

endmodule