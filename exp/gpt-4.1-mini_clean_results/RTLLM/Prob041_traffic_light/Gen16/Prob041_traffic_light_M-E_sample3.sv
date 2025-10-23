module traffic_light (
    input         rst_n,
    input         clk,
    input         pass_request,
    output reg [7:0] clock,
    output        red,
    output        yellow,
    output        green
);

    // Define states
    localparam [1:0]
        IDLE   = 2'b00,
        RED    = 2'b01,
        GREEN  = 2'b10,
        YELLOW = 2'b11;

    // Timing constants
    localparam integer RED_TIME    = 8'd10;
    localparam integer YELLOW_TIME = 8'd5;
    localparam integer GREEN_TIME  = 8'd60;
    localparam integer GREEN_SHORT = 8'd10;

    reg [1:0] state, next_state;
    reg [7:0] cnt, next_cnt;
    reg green_shortened_flag;

    // State and counter registers
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= IDLE;
            cnt <= 8'd0;
            green_shortened_flag <= 1'b0;
        end else begin
            state <= next_state;
            cnt <= next_cnt;
            // green_shortened_flag set/reset in sequential block below
        end
    end

    // Next state and counter logic
    always @(*) begin
        // Defaults to hold values
        next_state = state;
        next_cnt = cnt;

        case(state)
            IDLE: begin
                next_state = RED;
                next_cnt = RED_TIME;
            end

            RED: begin
                if (cnt == 0) begin
                    next_state = GREEN;
                    next_cnt = GREEN_TIME;
                end else begin
                    next_cnt = cnt - 1;
                end
            end

            GREEN: begin
                // If pass_request and not shortened and remaining green > 10, shorten the time
                if (pass_request && !green_shortened_flag && (cnt > GREEN_SHORT)) begin
                    next_cnt = GREEN_SHORT;
                end else if (cnt == 0) begin
                    next_state = YELLOW;
                    next_cnt = YELLOW_TIME;
                end else begin
                    next_cnt = cnt - 1;
                end
            end

            YELLOW: begin
                if (cnt == 0) begin
                    next_state = RED;
                    next_cnt = RED_TIME;
                end else begin
                    next_cnt = cnt - 1;
                end
            end

            default: begin
                next_state = IDLE;
                next_cnt = 8'd0;
            end
        endcase
    end

    // green_shortened_flag update sequentially
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            green_shortened_flag <= 1'b0;
        end else begin
            if (state != GREEN) begin
                // Reset flag whenever we leave GREEN state
                green_shortened_flag <= 1'b0;
            end else if (pass_request && !green_shortened_flag && (cnt > GREEN_SHORT)) begin
                // Set flag on shortening event
                green_shortened_flag <= 1'b1;
            end
        end
    end

    // Outputs combinationally based on state
    assign red    = (state == RED);
    assign yellow = (state == YELLOW);
    assign green  = (state == GREEN);

    // clock output driven by counter register
    always @(*) begin
        clock = cnt;
    end

endmodule