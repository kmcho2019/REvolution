module traffic_light (
    input  wire       rst_n,
    input  wire       clk,
    input  wire       pass_request,
    output reg  [7:0] clock,
    output reg        red,
    output reg        yellow,
    output reg        green
);

localparam [1:0]
    RED    = 2'd0,
    GREEN  = 2'd1,
    YELLOW = 2'd2;

localparam [7:0]
    RED_TIME    = 8'd10,
    YELLOW_TIME = 8'd5,
    GREEN_TIME  = 8'd60,
    SHORT_GREEN = 8'd10;

reg [1:0] state;
reg [7:0] timer;

// Clock enable for timer decrement to reduce switching
wire timer_decr_enable;
assign timer_decr_enable = (timer != 0);

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= RED;
        timer <= RED_TIME;
        {red, yellow, green} <= 3'b100;
        clock <= RED_TIME;
    end else begin
        // Timer counting and state transitions
        if (timer == 0) begin
            // Transition to next state and preset timer accordingly
            case (state)
                RED: begin
                    state <= GREEN;
                    timer <= GREEN_TIME;
                    red <= 1'b0;
                    yellow <= 1'b0;
                    green <= 1'b1;
                    clock <= GREEN_TIME;
                end
                GREEN: begin
                    state <= YELLOW;
                    timer <= YELLOW_TIME;
                    red <= 1'b0;
                    yellow <= 1'b1;
                    green <= 1'b0;
                    clock <= YELLOW_TIME;
                end
                YELLOW: begin
                    state <= RED;
                    timer <= RED_TIME;
                    red <= 1'b1;
                    yellow <= 1'b0;
                    green <= 1'b0;
                    clock <= RED_TIME;
                end
                default: begin
                    state <= RED;
                    timer <= RED_TIME;
                    red <= 1'b1;
                    yellow <= 1'b0;
                    green <= 1'b0;
                    clock <= RED_TIME;
                end
            endcase
        end else begin
            // In green state, if pass_request and timer > SHORT_GREEN, clamp timer to SHORT_GREEN
            if (state == GREEN && pass_request && timer > SHORT_GREEN) begin
                timer <= SHORT_GREEN;
                clock <= SHORT_GREEN;
            end else if (timer_decr_enable) begin
                timer <= timer - 1;
                clock <= timer - 1;
            end else begin
                clock <= timer;
            end
            // Outputs remain unchanged in this cycle
        end
    end
end

endmodule