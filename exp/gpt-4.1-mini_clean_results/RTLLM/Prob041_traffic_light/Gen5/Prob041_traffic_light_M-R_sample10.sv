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

// Timing constants
localparam RED_TIME    = 8'd10;
localparam YELLOW_TIME = 8'd5;
localparam GREEN_TIME  = 8'd60;
localparam SHORT_GREEN = 8'd10;

reg [1:0] state, next_state;
reg [7:0] timer, next_timer;
reg shortened_flag, next_shortened_flag;

// State register
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= RED;
        timer <= RED_TIME;
        shortened_flag <= 1'b0;
    end else begin
        state <= next_state;
        timer <= next_timer;
        shortened_flag <= next_shortened_flag;
    end
end

// Next state and timer logic
always @(*) begin
    next_state = state;
    next_timer = timer;
    next_shortened_flag = shortened_flag;

    case (state)
        RED: begin
            if (timer == 0) begin
                next_state = GREEN;
                next_timer = GREEN_TIME;
                next_shortened_flag = 1'b0; // reset shorten flag on green start
            end else begin
                next_timer = timer - 1;
            end
        end

        GREEN: begin
            if (timer == 0) begin
                next_state = YELLOW;
                next_timer = YELLOW_TIME;
                next_shortened_flag = 1'b0;
            end else begin
                // Check for pedestrian button and shorten green if conditions met
                if (pass_request && !shortened_flag && timer > SHORT_GREEN) begin
                    next_timer = SHORT_GREEN;
                    next_shortened_flag = 1'b1;
                end else begin
                    next_timer = timer - 1;
                end
            end
        end

        YELLOW: begin
            if (timer == 0) begin
                next_state = RED;
                next_timer = RED_TIME;
            end else begin
                next_timer = timer - 1;
            end
        end

        default: begin
            next_state = RED;
            next_timer = RED_TIME;
            next_shortened_flag = 1'b0;
        end
    endcase
end

// Outputs: continuous assignments based on state
assign red    = (state == RED);
assign green  = (state == GREEN);
assign yellow = (state == YELLOW);
assign clock  = timer;

endmodule