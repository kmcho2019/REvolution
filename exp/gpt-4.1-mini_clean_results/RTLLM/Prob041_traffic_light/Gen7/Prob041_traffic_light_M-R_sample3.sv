module traffic_light (
    input wire rst_n,
    input wire clk,
    input wire pass_request,
    output wire [7:0] clock,
    output wire red,
    output wire yellow,
    output wire green
);

localparam RED    = 2'd0;
localparam GREEN  = 2'd1;
localparam YELLOW = 2'd2;

localparam RED_TIME    = 8'd10;
localparam YELLOW_TIME = 8'd5;
localparam GREEN_TIME  = 8'd60;
localparam SHORT_GREEN = 8'd10;

reg [1:0] state, next_state;
reg [7:0] timer, next_timer;

// State transition logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= RED;
    end else begin
        state <= next_state;
    end
end

// Timer update logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        timer <= RED_TIME;
    end else begin
        timer <= next_timer;
    end
end

// Next state and next timer combinational logic
always @(*) begin
    // Default assignments
    next_state = state;
    next_timer = timer;

    case (state)
        RED: begin
            if (timer == 0) begin
                next_state = GREEN;
                next_timer = GREEN_TIME;
            end else begin
                next_timer = timer - 1;
            end
        end

        GREEN: begin
            if (timer == 0) begin
                next_state = YELLOW;
                next_timer = YELLOW_TIME;
            end else if (pass_request && timer > SHORT_GREEN) begin
                // Shorten green timer when request occurs and timer > 10
                next_timer = SHORT_GREEN;
            end else begin
                next_timer = timer - 1;
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
        end
    endcase
end

// Output assignments
assign red    = (state == RED);
assign green  = (state == GREEN);
assign yellow = (state == YELLOW);
assign clock  = timer;

endmodule