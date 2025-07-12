module traffic_light (
    input  wire       rst_n,
    input  wire       clk,
    input  wire       pass_request,
    output reg [7:0]  clock,
    output reg        red,
    output reg        yellow,
    output reg        green
);

// State encoding
localparam idle      = 2'd0;
localparam s1_red    = 2'd1;
localparam s3_green  = 2'd2;
localparam s2_yellow = 2'd3;

// Duration parameters (clock cycles)
localparam RED_TIME    = 8'd10;
localparam GREEN_TIME  = 8'd60;
localparam YELLOW_TIME = 8'd5;
localparam SHORT_GREEN = 8'd10;

reg [1:0] state, next_state;
reg [7:0] cnt, next_cnt;

// Internal registers for previous outputs
reg p_red, p_yellow, p_green;

// Flag to indicate green shortening done this green phase
reg green_shortened, next_green_shortened;

// State and counter sequential update
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state           <= idle;
        cnt             <= 8'd0;
        red             <= 1'b0;
        yellow          <= 1'b0;
        green           <= 1'b0;
        p_red           <= 1'b0;
        p_yellow        <= 1'b0;
        p_green         <= 1'b0;
        green_shortened <= 1'b0;
    end else begin
        state           <= next_state;
        cnt             <= next_cnt;
        red             <= p_red;
        yellow          <= p_yellow;
        green           <= p_green;
        p_red           <= red;
        p_yellow        <= yellow;
        p_green         <= green;
        green_shortened <= next_green_shortened;
    end
end

// Next state and counter logic
always @(*) begin
    // Default next state and cnt values
    next_state = state;
    next_cnt   = cnt;
    next_green_shortened = green_shortened;

    case(state)
        idle: begin
            // Immediately move to s1_red and load red timer
            next_state = s1_red;
            next_cnt   = RED_TIME;
            next_green_shortened = 1'b0;
        end
        s1_red: begin
            // Lights: red=1,yellow=0,green=0
            // Timer counts down
            // When cnt==0 move to s3_green and load green timer
            if (cnt == 0) begin
                next_state = s3_green;
                next_green_shortened = 1'b0; // reset green shorten flag
                next_cnt = GREEN_TIME;
            end else begin
                next_cnt = cnt - 1;
            end
        end
        s3_green: begin
            // Lights: green=1,yellow=0,red=0
            // Check pass_request to shorten green time
            // Only shorten once per green phase, and only if cnt > SHORT_GREEN
            if (pass_request && !green_shortened && (cnt > SHORT_GREEN)) begin
                next_cnt = SHORT_GREEN;
                next_green_shortened = 1'b1;
            end else if (cnt == 0) begin
                next_state = s2_yellow;
                next_cnt = YELLOW_TIME;
            end else begin
                next_cnt = cnt - 1;
            end
        end
        s2_yellow: begin
            // Lights: yellow=1,red=0,green=0
            // Timer counts down
            // When cnt==0 move to s1_red and load red timer
            if (cnt == 0) begin
                next_state = s1_red;
                next_cnt = RED_TIME;
            end else begin
                next_cnt = cnt - 1;
            end
        end
        default: begin
            // Fallback to idle
            next_state = idle;
            next_cnt = 8'd0;
            next_green_shortened = 1'b0;
        end
    endcase
end

// Output signals p_red, p_yellow, p_green updated combinationally based on next_state
always @(*) begin
    // Default outputs off
    p_red = 1'b0;
    p_yellow = 1'b0;
    p_green = 1'b0;

    case(next_state)
        idle: begin
            p_red = 1'b0; p_yellow = 1'b0; p_green = 1'b0;
        end
        s1_red: begin
            p_red = 1'b1; p_yellow = 1'b0; p_green = 1'b0;
        end
        s3_green: begin
            p_red = 1'b0; p_yellow = 1'b0; p_green = 1'b1;
        end
        s2_yellow: begin
            p_red = 1'b0; p_yellow = 1'b1; p_green = 1'b0;
        end
        default: begin
            p_red = 1'b0; p_yellow = 1'b0; p_green = 1'b0;
        end
    endcase
end

// Assign the current counter value to clock output for external observation
always @(*) begin
    clock = cnt;
end

endmodule