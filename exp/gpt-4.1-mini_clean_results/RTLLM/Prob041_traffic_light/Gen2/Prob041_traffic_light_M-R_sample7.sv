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
localparam idle      = 2'd0;
localparam s1_red    = 2'd1;
localparam s2_yellow = 2'd2;
localparam s3_green  = 2'd3;

// State durations
localparam RED_TIME    = 8'd10;
localparam YELLOW_TIME = 8'd5;
localparam GREEN_TIME  = 8'd60;
localparam SHORT_GREEN = 8'd10;

reg [1:0] state, next_state;
reg [7:0] cnt, next_cnt;
reg shorten_done; // Flag to avoid multiple shortenings per green phase

// State register update and next state logic on counter zero
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= idle;
        shorten_done <= 1'b0;
    end else begin
        // State transition occurs only when counter reaches 0
        if (cnt == 0) begin
            case(state)
                idle:      state <= s1_red;
                s1_red:    state <= s3_green;
                s3_green:  state <= s2_yellow;
                s2_yellow: state <= s1_red;
                default:   state <= idle;
            endcase
            shorten_done <= 1'b0; // Reset shortening flag on state change
        end
    end
end

// Counter loading and countdown logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt <= 8'd0;
    end else begin
        if (cnt == 0) begin
            // Load new count based on next state
            case (state)
                idle:      cnt <= RED_TIME - 1;
                s1_red:    cnt <= RED_TIME - 1;
                s3_green:  cnt <= GREEN_TIME - 1;
                s2_yellow: cnt <= YELLOW_TIME - 1;
                default:   cnt <= 8'd0;
            endcase
        end else begin
            // Countdown logic
            // Handle pass_request shortening in green state only once per green phase
            if (state == s3_green && pass_request && (cnt > SHORT_GREEN - 1) && !shorten_done) begin
                cnt <= SHORT_GREEN - 1;
                shorten_done <= 1'b1;
            end else begin
                cnt <= cnt - 1;
            end
        end
    end
end

// Outputs driven combinationally by current state
assign red    = (state == s1_red);
assign yellow = (state == s2_yellow);
assign green  = (state == s3_green);

assign clock = cnt;

endmodule