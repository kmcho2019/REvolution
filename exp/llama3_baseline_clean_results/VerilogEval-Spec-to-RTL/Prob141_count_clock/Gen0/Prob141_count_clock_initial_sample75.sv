module TopModule(
    input clk,
    input reset,
    input ena,
    output pm,
    output [7:0] hh,
    output [7:0] mm,
    output [7:0] ss
);

// Define the BCD counters
reg [3:0] sec;
reg [3:0] min;
reg [3:0] hour;

// Define the pm signal
reg pm_reg;

// Define the initial values of the counters
initial sec = 0;
initial min = 0;
initial hour = 1;
initial pm_reg = 0;

// Define the counters' increment logic
always @(posedge clk) begin
    if (reset) begin // Reset has higher priority
        sec <= 0;
        min <= 0;
        hour <= 1;
        pm_reg <= 0;
    end else if (ena) begin // Increment the counters when ena is asserted
        if (sec == 9'd59) begin // Check if seconds counter has reached 59
            sec <= 0;
            if (min == 9'd59) begin // Check if minutes counter has reached 59
                min <= 0;
                if (hour == 9'd12) begin // Check if hours counter has reached 12
                    hour <= 1;
                    pm_reg <= ~pm_reg; // Toggle the pm signal
                end else if (hour == 9'd12 && pm_reg == 1'b1) begin
                    hour <= 1;
                    pm_reg <= 0;
                end else begin
                    hour <= hour + 1;
                end
            end else begin
                min <= min + 1;
            end
        end else begin
            sec <= sec + 1;
        end
    end
end

// Assign the counters to the output ports
assign hh = (hour[3] << 3) | (hour[2] << 2) | (hour[1] << 1) | hour[0];
assign mm = (min[3] << 3) | (min[2] << 2) | (min[1] << 1) | min[0];
assign ss = (sec[3] << 3) | (sec[2] << 2) | (sec[1] << 1) | sec[0];
assign pm = pm_reg;

endmodule