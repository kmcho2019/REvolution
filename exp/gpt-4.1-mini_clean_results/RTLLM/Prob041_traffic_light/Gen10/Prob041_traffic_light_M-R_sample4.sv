module traffic_light (
    input  wire       rst_n,
    input  wire       clk,
    input  wire       pass_request,
    output wire [7:0] clock,
    output wire       red,
    output wire       yellow,
    output wire       green
);

// State encoding
localparam RED    = 2'd0;
localparam GREEN  = 2'd1;
localparam YELLOW = 2'd2;

// Timing parameters
localparam RED_TIME    = 8'd10;
localparam YELLOW_TIME = 8'd5;
localparam GREEN_TIME  = 8'd60;
localparam SHORT_GREEN = 8'd10;

reg [1:0] state, next_state;
reg [7:0] timer, next_timer;

// Next state logic: Moore FSM with states transition only at timer=0
always @(*) begin
    case (state)
        RED:    next_state = (timer == 8'd0) ? GREEN : RED;
        GREEN:  next_state = (timer == 8'd0) ? YELLOW : GREEN;
        YELLOW: next_state = (timer == 8'd0) ? RED : YELLOW;
        default: next_state = RED;
    endcase
end

// Timer reload values per state
function [7:0] reload_value(input [1:0] st);
    case (st)
        RED:    reload_value = RED_TIME;
        GREEN:  reload_value = GREEN_TIME;
        YELLOW: reload_value = YELLOW_TIME;
        default: reload_value = RED_TIME;
    endcase
endfunction

// Sequential logic: state update and timer update
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= RED;
        timer <= RED_TIME;
    end else begin
        state <= next_state;
        if (timer == 8'd0) begin
            // On state transition, load full timer of next state
            timer <= reload_value(next_state);
        end else if (state == GREEN && pass_request && timer > SHORT_GREEN) begin
            // Clamp green timer to SHORT_GREEN if pass_request asserted and timer > SHORT_GREEN
            timer <= SHORT_GREEN;
        end else begin
            // Normal countdown
            timer <= timer - 1;
        end
    end
end

// Outputs driven combinationally from state
assign red    = (state == RED);
assign yellow = (state == YELLOW);
assign green  = (state == GREEN);
assign clock  = timer;

endmodule