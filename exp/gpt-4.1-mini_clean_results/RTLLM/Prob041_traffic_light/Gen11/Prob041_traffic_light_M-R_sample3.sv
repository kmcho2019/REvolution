module traffic_light (
    input  wire       rst_n,
    input  wire       clk,
    input  wire       pass_request,
    output reg  [7:0] clock,
    output reg        red,
    output reg        yellow,
    output reg        green
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

always @(*) begin
    // Default assignments
    next_state = state;
    next_timer = timer;

    case (state)
        RED: begin
            red = 1'b1; yellow = 1'b0; green = 1'b0;
            if (timer == 8'd0) begin
                next_state = GREEN;
                next_timer = GREEN_TIME;
            end else begin
                next_timer = timer - 1;
            end
        end

        GREEN: begin
            red = 1'b0; yellow = 1'b0; green = 1'b1;
            // Pedestrian button shortens green time to SHORT_GREEN if timer > SHORT_GREEN
            if (pass_request && timer > SHORT_GREEN)
                next_timer = SHORT_GREEN;
            else if (timer == 8'd0) begin
                next_state = YELLOW;
                next_timer = YELLOW_TIME;
            end else begin
                // Normal countdown
                next_timer = timer - 1;
            end
        end

        YELLOW: begin
            red = 1'b0; yellow = 1'b1; green = 1'b0;
            if (timer == 8'd0) begin
                next_state = RED;
                next_timer = RED_TIME;
            end else begin
                next_timer = timer - 1;
            end
        end

        default: begin
            // Default fallback to RED
            red = 1'b1; yellow = 1'b0; green = 1'b0;
            next_state = RED;
            next_timer = RED_TIME;
        end
    endcase
end

// Sequential update of state, timer, and outputs
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= RED;
        timer <= RED_TIME;
        red <= 1'b1;
        yellow <= 1'b0;
        green <= 1'b0;
        clock <= RED_TIME;
    end else begin
        state <= next_state;
        timer <= next_timer;
        red <= red;
        yellow <= yellow;
        green <= green;
        clock <= next_timer;
    end
end

endmodule