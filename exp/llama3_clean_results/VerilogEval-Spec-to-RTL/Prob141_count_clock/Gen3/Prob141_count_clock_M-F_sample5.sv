module TopModule(
    input clk,
    input reset,
    input ena,
    output reg pm,
    output reg [7:0] hh,
    output reg [7:0] mm,
    output reg [7:0] ss
);

reg [3:0] hours_tens;
reg [3:0] hours_ones;
reg [3:0] minutes_tens;
reg [3:0] minutes_ones;
reg [3:0] seconds_tens;
reg [3:0] seconds_ones;
reg [3:0] decimal_hours;

assign hh = {hours_tens, hours_ones};
assign mm = {minutes_tens, minutes_ones};
assign ss = {seconds_tens, seconds_ones};

initial begin
    hours_tens = 4'd1;
    hours_ones = 4'd2;
    minutes_tens = 4'd0;
    minutes_ones = 4'd0;
    seconds_tens = 4'd0;
    seconds_ones = 4'd0;
    decimal_hours = 4'd0; // 12 in decimal
    pm = 1'b0;
end

always @(posedge clk) begin
    if (reset) begin
        hours_tens <= 4'd1;
        hours_ones <= 4'd2;
        minutes_tens <= 4'd0;
        minutes_ones <= 4'd0;
        seconds_tens <= 4'd0;
        seconds_ones <= 4'd0;
        decimal_hours <= 4'd0; // 12 in decimal
        pm <= 1'b0;
    end else if (ena) begin
        // Increment seconds
        if (seconds_ones == 4'd9) begin
            seconds_ones <= 4'd0;
            if (seconds_tens == 4'd5) begin
                seconds_tens <= 4'd0;
                // Increment minutes
                if (minutes_ones == 4'd9) begin
                    minutes_ones <= 4'd0;
                    if (minutes_tens == 4'd5) begin
                        minutes_tens <= 4'd0;
                        // Increment hours
                        if (decimal_hours == 4'd11) begin // 11 for PM 11
                            decimal_hours <= 4'd0; // Wrap around to 12 AM
                            pm <= 1'b0;
                        end else if (decimal_hours == 4'd0) begin // 12 AM
                            decimal_hours <= 4'd1; // 1 PM
                            pm <= 1'b1;
                        end else begin
                            decimal_hours <= decimal_hours + 1'b1;
                            if (decimal_hours == 4'd12) begin // 12 PM
                                pm <= 1'b0;
                            end
                        end
                        // Update BCD hours based on decimal hours
                        case (decimal_hours)
                            4'd0: begin hours_tens <= 4'd1; hours_ones <= 4'd2; end // 12
                            4'd1: begin hours_tens <= 4'd0; hours_ones <= 4'd1; end // 1
                            4'd2: begin hours_tens <= 4'd0; hours_ones <= 4'd2; end // 2
                            4'd3: begin hours_tens <= 4'd0; hours_ones <= 4'd3; end // 3
                            4'd4: begin hours_tens <= 4'd0; hours_ones <= 4'd4; end // 4
                            4'd5: begin hours_tens <= 4'd0; hours_ones <= 4'd5; end // 5
                            4'd6: begin hours_tens <= 4'd0; hours_ones <= 4'd6; end // 6
                            4'd7: begin hours_tens <= 4'd0; hours_ones <= 4'd7; end // 7
                            4'd8: begin hours_tens <= 4'd0; hours_ones <= 4'd8; end // 8
                            4'd9: begin hours_tens <= 4'd0; hours_ones <= 4'd9; end // 9
                            4'd10: begin hours_tens <= 4'd1; hours_ones <= 4'd0; end // 10
                            4'd11: begin hours_tens <= 4'd1; hours_ones <= 4'd1; end // 11
                            default: begin hours_tens <= 4'd1; hours_ones <= 4'd2; end // Default to 12
                        endcase
                    end else begin
                        minutes_tens <= minutes_tens + 1'b1;
                    end
                end else begin
                    minutes_ones <= minutes_ones + 1'b1;
                end
            end else begin
                seconds_tens <= seconds_tens + 1'b1;
            end
        end else begin
            seconds_ones <= seconds_ones + 1'b1;
        end
    end
end

endmodule