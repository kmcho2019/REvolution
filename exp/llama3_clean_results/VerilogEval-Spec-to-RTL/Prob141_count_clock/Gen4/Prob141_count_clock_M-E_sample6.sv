module TopModule(
    input clk,
    input reset,
    input ena,
    output reg pm,
    output reg [7:0] hh,
    output reg [7:0] mm,
    output reg [7:0] ss
);

// Define parameters for the FSM states
parameter STATE_RESET = 4'd0;
parameter STATE_HOUR_1 = 4'd1;
parameter STATE_HOUR_2 = 4'd2;
parameter STATE_HOUR_3 = 4'd3;
parameter STATE_HOUR_4 = 4'd4;
parameter STATE_HOUR_5 = 4'd5;
parameter STATE_HOUR_6 = 4'd6;
parameter STATE_HOUR_7 = 4'd7;
parameter STATE_HOUR_8 = 4'd8;
parameter STATE_HOUR_9 = 4'd9;
parameter STATE_HOUR_10 = 4'd10;
parameter STATE_HOUR_11 = 4'd11;
parameter STATE_HOUR_12 = 4'd12;

// Define parameters for the minute and second counters
parameter MAX_MINUTES = 6'd59;
parameter MAX_SECONDS = 6'd59;

// Internal counters for seconds, minutes, and hours
reg [5:0] seconds;
reg [5:0] minutes;
reg [3:0] hours;

// Synchronized reset signal
reg reset_sync;

// FSM state register
reg [3:0] state;

// BCD conversion module
module bcd_convert(
    input [5:0] value,
    output [7:0] bcd
);
    always @(value) begin
        bcd = {2'b0, value};
    end
endmodule

// Output signal generation module
module output_gen(
    input [3:0] hours,
    input [5:0] minutes,
    input [5:0] seconds,
    output reg pm,
    output reg [7:0] hh,
    output reg [7:0] mm,
    output reg [7:0] ss
);
    reg [7:0] hours_bcd;
    reg [7:0] minutes_bcd;
    reg [7:0] seconds_bcd;

    bcd_convert hours_conv(hours, hours_bcd);
    bcd_convert minutes_conv(minutes, minutes_bcd);
    bcd_convert seconds_conv(seconds, seconds_bcd);

    always @(hours, minutes, seconds) begin
        if (hours >= 4'd6) begin
            pm = 1'b1;
        end else begin
            pm = 1'b0;
        end

        hh = (hours == 4'd0) ? 8'd12 : hours_bcd;
        mm = minutes_bcd;
        ss = seconds_bcd;
    end
endmodule

// FSM module
module fsm(
    input clk,
    input reset,
    input ena,
    output reg [3:0] state,
    output reg [5:0] seconds,
    output reg [5:0] minutes,
    output reg [3:0] hours
);
    always @(posedge clk) begin
        if (reset) begin
            state <= STATE_RESET;
            seconds <= 6'd0;
            minutes <= 6'd0;
            hours <= 4'd0;
        end else if (ena) begin
            case (state)
                STATE_RESET: begin
                    state <= STATE_HOUR_1;
                    seconds <= 6'd0;
                    minutes <= 6'd0;
                    hours <= 4'd0;
                end
                STATE_HOUR_1: begin
                    if (seconds == MAX_SECONDS) begin
                        seconds <= 6'd0;
                        if (minutes == MAX_MINUTES) begin
                            minutes <= 6'd0;
                            if (hours == 4'd11) begin
                                hours <= 4'd0;
                            end else begin
                                hours <= hours + 1'b1;
                            end
                            state <= STATE_HOUR_1;
                        end else begin
                            minutes <= minutes + 1'b1;
                            state <= STATE_HOUR_1;
                        end
                    end else begin
                        seconds <= seconds + 1'b1;
                        state <= STATE_HOUR_1;
                    end
                end
                default: begin
                    state <= STATE_RESET;
                end
            endcase
        end
    end
endmodule

// Instantiate modules
fsm fsm_inst(clk, reset_sync, ena, state, seconds, minutes, hours);
output_gen output_gen_inst(hours, minutes, seconds, pm, hh, mm, ss);

// Synchronize reset signal
always @(posedge clk) begin
    reset_sync <= reset;
end

endmodule