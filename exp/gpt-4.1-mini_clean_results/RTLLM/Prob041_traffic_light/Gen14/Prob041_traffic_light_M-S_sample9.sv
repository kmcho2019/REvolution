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
    S_RED    = 2'd0,
    S_GREEN  = 2'd1,
    S_YELLOW = 2'd2;

// Timing constants
localparam [7:0]
    RED_TIME    = 8'd10,
    YELLOW_TIME = 8'd5,
    GREEN_TIME  = 8'd60,
    SHORT_GREEN = 8'd10;

reg [1:0] state, next_state;
reg [7:0] timer, next_timer;

// State and timer registers
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= S_RED;
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

    case (state)
        S_RED: begin
            if (timer == 0) begin
                next_state = S_GREEN;
                next_timer = GREEN_TIME;
            end else begin
                next_timer = timer - 1;
            end
        end

        S_GREEN: begin
            // Pedestrian button shortens green to 10 if timer > 10
            if (pass_request && (timer > SHORT_GREEN)) begin
                next_timer = SHORT_GREEN;
            end else if (timer == 0) begin
                next_state = S_YELLOW;
                next_timer = YELLOW_TIME;
            end else begin
                next_timer = timer - 1;
            end
        end

        S_YELLOW: begin
            if (timer == 0) begin
                next_state = S_RED;
                next_timer = RED_TIME;
            end else begin
                next_timer = timer - 1;
            end
        end

        default: begin
            next_state = S_RED;
            next_timer = RED_TIME;
        end
    endcase
end

// Outputs derived from state
assign red    = (state == S_RED);
assign yellow = (state == S_YELLOW);
assign green  = (state == S_GREEN);
assign clock  = timer;

endmodule