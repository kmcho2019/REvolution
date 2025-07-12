module traffic_light (
    input wire rst_n,
    input wire clk,
    input wire pass_request,
    output wire [7:0] clock,
    output wire red,
    output wire yellow,
    output wire green
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

// State register and counter update
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= idle;
        cnt <= 8'd0;
    end else begin
        state <= next_state;
        cnt <= next_cnt;
    end
end

// Next state and counter logic
always @(*) begin
    // Defaults to hold current state and decrement counter if >0
    next_state = state;
    if (cnt > 0)
        next_cnt = cnt - 1;
    else
        next_cnt = 0;

    case(state)
        idle: begin
            // Immediately transition to s1_red with red duration
            next_state = s1_red;
            next_cnt = RED_TIME - 1; // counts down from RED_TIME-1 to 0, total RED_TIME cycles
        end
        s1_red: begin
            if (cnt == 0) begin
                next_state = s3_green;
                next_cnt = GREEN_TIME - 1;
            end
        end
        s3_green: begin
            if (pass_request && (cnt > SHORT_GREEN)) begin
                // Shorten green time to 10 cycles if remaining is more than 10
                next_cnt = SHORT_GREEN - 1;
            end else if (cnt == 0) begin
                next_state = s2_yellow;
                next_cnt = YELLOW_TIME - 1;
            end
        end
        s2_yellow: begin
            if (cnt == 0) begin
                next_state = s1_red;
                next_cnt = RED_TIME - 1;
            end
        end
        default: begin
            next_state = idle;
            next_cnt = 8'd0;
        end
    endcase
end

// Outputs combinationally driven based on state
assign red    = (state == s1_red);
assign yellow = (state == s2_yellow);
assign green  = (state == s3_green);

// Output the current counter value
assign clock = cnt;

endmodule