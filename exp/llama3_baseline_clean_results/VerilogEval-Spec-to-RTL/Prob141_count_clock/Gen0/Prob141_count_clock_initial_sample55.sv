module TopModule(
    input clk,
    input reset,
    input ena,
    output reg pm,
    output reg [7:0] hh,
    output reg [7:0] mm,
    output reg [7:0] ss
);

reg [31:0] counter;  // counter to divide clock frequency
reg [5:0] seconds;   // seconds counter
reg [5:0] minutes;   // minutes counter
reg [3:0] hours;     // hours counter

always @(posedge clk) begin
    if (reset) begin
        // reset counters to initial values
        counter <= 32'd0;
        seconds <= 6'd0;
        minutes <= 6'd0;
        hours <= 4'd0;
        pm <= 1'b0;
    end else if (ena) begin
        // increment counters
        if (counter == 32'd25000000) begin  // assuming 25M Hz clock
            counter <= 32'd0;
            if (seconds == 6'd59) begin
                seconds <= 6'd0;
                if (minutes == 6'd59) begin
                    minutes <= 6'd0;
                    if (hours == 4'd12) begin
                        hours <= 4'd1;
                        pm <= ~pm;
                    end else if (hours == 4'd12 - 1) begin
                        hours <= 4'd0;
                        pm <= 1'b1;
                    end else begin
                        hours <= hours + 1;
                    end
                end else begin
                    minutes <= minutes + 1;
                end
            end else begin
                seconds <= seconds + 1;
            end
        end else begin
            counter <= counter + 1;
        end
    end
end

always @(posedge clk) begin
    // convert counters to BCD
    hh <= {1'b0, hours};
    mm <= {1'b0, minutes};
    ss <= {1'b0, seconds};
end

endmodule