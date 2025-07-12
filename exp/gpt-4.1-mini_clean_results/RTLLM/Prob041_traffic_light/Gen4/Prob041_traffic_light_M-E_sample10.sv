module traffic_light (
    input wire rst_n,
    input wire clk,
    input wire pass_request,
    output reg [7:0] clock,
    output reg red,
    output reg yellow,
    output reg green
);

// State encoding using localparams with explicit enumeration as requested
localparam [1:0]
    idle     = 2'd0,
    s1_red   = 2'd1,
    s2_yellow= 2'd2,
    s3_green = 2'd3;

// Duration constants
localparam [7:0]
    RED_TIME    = 8'd10,
    YELLOW_TIME = 8'd5,
    GREEN_TIME  = 8'd60,
    SHORT_GREEN = 8'd10;

reg [1:0] state, next_state;
reg [7:0] cnt, next_cnt;

// Previous output registers (to detect edges)
reg p_red, p_yellow, p_green;
reg next_p_red, next_p_yellow, next_p_green;

// FSM state transition and output logic
always @(*) begin
    // default assignments
    next_state = state;
    next_cnt = cnt;
    next_p_red = p_red;
    next_p_yellow = p_yellow;
    next_p_green = p_green;

    case (state)
        idle: begin
            // outputs off in idle
            next_p_red = 1'b0;
            next_p_yellow = 1'b0;
            next_p_green = 1'b0;
            // move immediately to red
            next_state = s1_red;
            next_cnt = RED_TIME;
        end

        s1_red: begin
            // red light on
            next_p_red = 1'b1;
            next_p_yellow = 1'b0;
            next_p_green = 1'b0;

            if (cnt == 0) begin
                next_state = s3_green;
                next_cnt = GREEN_TIME;
            end else begin
                next_cnt = cnt - 1;
            end
        end

        s2_yellow: begin
            // yellow light on
            next_p_red = 1'b0;
            next_p_yellow = 1'b1;
            next_p_green = 1'b0;

            if (cnt == 0) begin
                next_state = s1_red;
                next_cnt = RED_TIME;
            end else begin
                next_cnt = cnt - 1;
            end
        end

        s3_green: begin
            // green light on
            next_p_red = 1'b0;
            next_p_yellow = 1'b0;
            next_p_green = 1'b1;

            // Pedestrian request logic: if pass_request and remaining green > 10, clamp to 10
            if (pass_request && cnt > SHORT_GREEN) begin
                next_cnt = SHORT_GREEN - 1;  // Subtract 1 because we decrement below
            end else if (cnt == 0) begin
                next_state = s2_yellow;
                next_cnt = YELLOW_TIME;
            end else begin
                next_cnt = cnt - 1;
            end
        end

        default: begin
            // safe fallback
            next_state = idle;
            next_cnt = RED_TIME;
            next_p_red = 1'b0;
            next_p_yellow = 1'b0;
            next_p_green = 1'b0;
        end
    endcase
end

// Sequential block: state, counter, and output registers update
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= idle;
        cnt <= 8'd0;
        red <= 1'b0;
        yellow <= 1'b0;
        green <= 1'b0;
        p_red <= 1'b0;
        p_yellow <= 1'b0;
        p_green <= 1'b0;
    end else begin
        state <= next_state;
        cnt <= next_cnt;
        // update outputs synchronously
        red <= next_p_red;
        yellow <= next_p_yellow;
        green <= next_p_green;
        // update previous output registers for edge detection (if needed)
        p_red <= next_p_red;
        p_yellow <= next_p_yellow;
        p_green <= next_p_green;
    end
end

// output the counter value
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        clock <= 8'd0;
    end else begin
        clock <= cnt;
    end
end

endmodule