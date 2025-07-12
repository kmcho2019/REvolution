module TopModule(
    input           clk,
    input           reset,
    input           ena,
    output          pm,
    output [7:0]    hh,
    output [7:0]    mm,
    output [7:0]    ss
);

reg [3:0] hour_tens;
reg [3:0] hour_ones;
reg [3:0] minute_tens;
reg [3:0] minute_ones;
reg [3:0] second_tens;
reg [3:0] second_ones;

assign hh = {hour_tens, hour_ones};
assign mm = {minute_tens, minute_ones};
assign ss = {second_tens, second_ones};

always @(posedge clk) begin
    if (reset) begin
        // Reset the clock to "12:00 AM"
        hour_tens <= 1;
        hour_ones <= 2;
        minute_tens <= 0;
        minute_ones <= 0;
        second_tens <= 0;
        second_ones <= 0;
    end else if (ena) begin
        // Increment seconds
        if (second_ones == 9) begin
            second_ones <= 0;
            if (second_tens == 5) begin
                second_tens <= 0;
                // Increment minutes
                if (minute_ones == 9) begin
                    minute_ones <= 0;
                    if (minute_tens == 5) begin
                        minute_tens <= 0;
                        // Increment hours
                        if (hour_ones == 9) begin
                            hour_ones <= 0;
                            if (hour_tens == 1) begin
                                hour_tens <= 0;
                                hour_ones <= 2; // Wrap around to 12
                            end else begin
                                hour_tens <= hour_tens + 1;
                            end
                        end else begin
                            hour_ones <= hour_ones + 1;
                            // Check for hour wrapping around
                            if ((hour_tens == 1 && hour_ones > 2) || (hour_tens > 1)) begin
                                hour_tens <= 0;
                                hour_ones <= 2;
                            end
                        end
                    end else begin
                        minute_tens <= minute_tens + 1;
                    end
                end else begin
                    minute_ones <= minute_ones + 1;
                end
            end else begin
                second_tens <= second_tens + 1;
            end
        end else begin
            second_ones <= second_ones + 1;
        end
    end
end

// Determine if it is PM based on the hour
assign pm = (hour_tens == 0 && hour_ones > 6) || (hour_tens == 1);

endmodule