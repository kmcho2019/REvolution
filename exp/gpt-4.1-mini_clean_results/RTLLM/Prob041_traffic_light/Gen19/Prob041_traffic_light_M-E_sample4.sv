module traffic_light(
    input  wire       rst_n,
    input  wire       clk,
    input  wire       pass_request,
    output reg  [7:0] clock,
    output reg        red,
    output reg        yellow,
    output reg        green
);

// State encoding
localparam idle     = 2'd0;
localparam s1_red   = 2'd1;
localparam s2_yellow= 2'd2;
localparam s3_green = 2'd3;

// Timing constants
localparam RED_TIME     = 8'd10;
localparam YELLOW_TIME  = 8'd5;
localparam GREEN_TIME   = 8'd60;
localparam SHORT_GREEN  = 8'd10;

reg [1:0] state, next_state;
reg [7:0] cnt, next_cnt;

// For previous outputs
reg p_red, p_yellow, p_green;
reg next_p_red, next_p_yellow, next_p_green;

// State and counter sequential update
always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        state     <= idle;
        cnt       <= 8'd10;
        red       <= 0;
        yellow    <= 0;
        green     <= 0;
        p_red     <= 0;
        p_yellow  <= 0;
        p_green   <= 0;
        clock     <= 8'd0;
    end else begin
        state     <= next_state;
        cnt       <= next_cnt;
        red       <= next_p_red;
        yellow    <= next_p_yellow;
        green     <= next_p_green;
        p_red     <= next_p_red;
        p_yellow  <= next_p_yellow;
        p_green   <= next_p_green;
        clock     <= cnt;
    end
end

// Next state and counter logic
always @(*) begin
    // Default assignments
    next_state = state;
    next_cnt = cnt;
    next_p_red = 1'b0;
    next_p_yellow = 1'b0;
    next_p_green = 1'b0;

    case(state)
        idle: begin
            // Immediately go to red state with RED_TIME
            next_state = s1_red;
            next_cnt = RED_TIME;
            next_p_red = 1'b1;
        end

        s1_red: begin
            next_p_red = 1'b1;
            if(cnt == 0) begin
                next_state = s3_green;
                next_cnt = GREEN_TIME;
            end else begin
                next_cnt = cnt - 1;
            end
        end

        s2_yellow: begin
            next_p_yellow = 1'b1;
            if(cnt == 0) begin
                next_state = s1_red;
                next_cnt = RED_TIME;
            end else begin
                next_cnt = cnt - 1;
            end
        end

        s3_green: begin
            next_p_green = 1'b1;
            // Handle pedestrian request to shorten green time
            if(pass_request && (cnt > SHORT_GREEN)) begin
                next_cnt = SHORT_GREEN;
            end else if(cnt == 0) begin
                next_state = s2_yellow;
                next_cnt = YELLOW_TIME;
            end else begin
                next_cnt = cnt - 1;
            end
        end

        default: begin
            // Safety fallback
            next_state = s1_red;
            next_cnt = RED_TIME;
            next_p_red = 1'b1;
        end
    endcase
end

endmodule