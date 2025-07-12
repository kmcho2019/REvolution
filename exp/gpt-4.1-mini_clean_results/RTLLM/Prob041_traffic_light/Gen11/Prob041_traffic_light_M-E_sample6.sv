module traffic_light (
    input  wire       rst_n,
    input  wire       clk,
    input  wire       pass_request,
    output reg [7:0]  clock,
    output reg        red,
    output reg        yellow,
    output reg        green
);

// Define states
typedef enum logic [1:0] {
    idle     = 2'd0,
    s1_red   = 2'd1,
    s2_yellow= 2'd2,
    s3_green = 2'd3
} state_t;

state_t state, next_state;

// Timing constants
localparam IDLE_CNT     = 8'd0;
localparam RED_TIME     = 8'd10;
localparam YELLOW_TIME  = 8'd5;
localparam GREEN_TIME   = 8'd60;
localparam SHORT_GREEN  = 8'd10;

// Internal counter and max count for current state
reg [7:0] cnt;
reg [7:0] max_cnt;

// Next values for outputs
reg p_red, p_yellow, p_green;

// State transition combinational logic
always @(*) begin
    // Defaults
    next_state = state;
    case(state)
        idle: begin
            next_state = s1_red; // move immediately to s1_red
        end
        s1_red: begin
            if (cnt >= max_cnt) next_state = s3_green;
        end
        s2_yellow: begin
            if (cnt >= max_cnt) next_state = s1_red;
        end
        s3_green: begin
            if (cnt >= max_cnt) next_state = s2_yellow;
        end
        default: next_state = idle;
    endcase
end

// Sequential block: state, counter, max_cnt update and output next values
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state   <= idle;
        cnt     <= 8'd0;
        max_cnt <= 8'd10; // start with RED_TIME
        p_red   <= 1'b0;
        p_yellow<= 1'b0;
        p_green <= 1'b0;
    end else begin
        state <= next_state;
        // Outputs set according to next_state for Moore FSM
        case(next_state)
            idle: begin
                p_red    <= 1'b0;
                p_yellow <= 1'b0;
                p_green  <= 1'b0;
                max_cnt  <= IDLE_CNT;
            end
            s1_red: begin
                p_red    <= 1'b1;
                p_yellow <= 1'b0;
                p_green  <= 1'b0;
                max_cnt  <= RED_TIME;
            end
            s2_yellow: begin
                p_red    <= 1'b0;
                p_yellow <= 1'b1;
                p_green  <= 1'b0;
                max_cnt  <= YELLOW_TIME;
            end
            s3_green: begin
                p_red    <= 1'b0;
                p_yellow <= 1'b0;
                p_green  <= 1'b1;
                max_cnt  <= GREEN_TIME;
            end
        endcase

        // Counter logic
        if (state != next_state) begin
            // State changed, reset count to zero
            cnt <= 8'd0;
        end else begin
            // Within same state, count up unless at max
            if (cnt < max_cnt) begin
                // For green state, check pedestrian button to shorten time
                if (state == s3_green && pass_request) begin
                    // If remaining green time > SHORT_GREEN, clamp count to (max_cnt - SHORT_GREEN)
                    // so remaining time is SHORT_GREEN cycles
                    if ((max_cnt - cnt) > SHORT_GREEN) begin
                        cnt <= max_cnt - SHORT_GREEN;
                    end else begin
                        cnt <= cnt + 8'd1;
                    end
                end else begin
                    cnt <= cnt + 8'd1;
                end
            end
        end
    end
end

// Assign output signals from previous output registers as per problem statement
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        red    <= 1'b0;
        yellow <= 1'b0;
        green  <= 1'b0;
        clock  <= 8'd0;
    end else begin
        red    <= p_red;
        yellow <= p_yellow;
        green  <= p_green;
        clock  <= cnt;
    end
end

endmodule