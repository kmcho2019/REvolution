module traffic_light(
    input        rst_n,
    input        clk,
    input        pass_request,
    output reg [7:0] clock,
    output reg   red,
    output reg   yellow,
    output reg   green
);

// Timing constants
localparam IDLE_TIME   = 8'd1;
localparam RED_TIME    = 8'd10;
localparam YELLOW_TIME = 8'd5;
localparam GREEN_TIME  = 8'd60;
localparam GREEN_SHORT = 8'd10;

// State encoding
localparam [1:0]
    IDLE   = 2'b00,
    RED    = 2'b01,
    GREEN  = 2'b10,
    YELLOW = 2'b11;

reg [1:0] state, next_state;
reg [7:0] timer, next_timer;
reg       shorten_green; // flag to indicate green time shortening requested

// State and timer update sequential block
always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        state <= IDLE;
        timer <= IDLE_TIME;
        shorten_green <= 1'b0;
    end else begin
        state <= next_state;
        timer <= next_timer;
        shorten_green <= (state == GREEN && pass_request && timer > GREEN_SHORT) ? 1'b1 :
                         (state != GREEN) ? 1'b0 : shorten_green;
    end
end

// Next state and timer logic combinational block
always @(*) begin
    next_state = state;
    next_timer = timer;

    case(state)
        IDLE: begin
            // Immediately move to RED after IDLE_TIME expires
            if(timer == 0) begin
                next_state = RED;
                next_timer = RED_TIME;
            end else begin
                next_timer = timer - 1;
            end
        end

        RED: begin
            if(timer == 0) begin
                next_state = GREEN;
                next_timer = GREEN_TIME;
            end else begin
                next_timer = timer - 1;
            end
        end

        GREEN: begin
            if(timer == 0) begin
                next_state = YELLOW;
                next_timer = YELLOW_TIME;
            end else if(shorten_green && timer > GREEN_SHORT) begin
                // Apply shortening only once per request
                next_timer = GREEN_SHORT;
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
            next_state = IDLE;
            next_timer = IDLE_TIME;
        end
    endcase
end

// Outputs synchronous to clk and reset
always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        red    <= 1'b0;
        yellow <= 1'b0;
        green  <= 1'b0;
        clock  <= 8'd0;
    end else begin
        red    <= (state == RED);
        yellow <= (state == YELLOW);
        green  <= (state == GREEN);
        clock  <= timer;
    end
end

endmodule