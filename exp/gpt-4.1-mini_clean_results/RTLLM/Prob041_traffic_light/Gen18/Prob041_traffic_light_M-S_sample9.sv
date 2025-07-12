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
localparam [1:0]
    RED    = 2'b00,
    GREEN  = 2'b01,
    YELLOW = 2'b10;

// Timing parameters
localparam [7:0]
    RED_TIME    = 8'd10,
    YELLOW_TIME = 8'd5,
    GREEN_TIME  = 8'd60,
    SHORT_GREEN = 8'd10;

reg [1:0] state, next_state;
reg [7:0] timer, next_timer;

// State and timer registers update
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= RED;
        timer <= RED_TIME;
    end else begin
        state <= next_state;
        timer <= next_timer;
    end
end

// Next state and timer logic
always @(*) begin
    next_state = state;
    next_timer = timer;

    case(state)
        RED: begin
            if(timer == 0) begin
                next_state = GREEN;
                next_timer = GREEN_TIME;
            end else begin
                next_timer = timer - 1;
            end
        end

        GREEN: begin
            // Shorten green timer if pedestrian requests and time > SHORT_GREEN
            if(pass_request && (timer > SHORT_GREEN)) begin
                next_timer = SHORT_GREEN;
            end else if(timer == 0) begin
                next_state = YELLOW;
                next_timer = YELLOW_TIME;
            end else begin
                next_timer = timer - 1;
            end
        end

        YELLOW: begin
            if(timer == 0) begin
                next_state = RED;
                next_timer = RED_TIME;
            end else begin
                next_timer = timer - 1;
            end
        end

        default: begin
            next_state = RED;
            next_timer = RED_TIME;
        end
    endcase
end

// Outputs assigned from state
assign red    = (state == RED);
assign green  = (state == GREEN);
assign yellow = (state == YELLOW);
assign clock  = timer;

endmodule