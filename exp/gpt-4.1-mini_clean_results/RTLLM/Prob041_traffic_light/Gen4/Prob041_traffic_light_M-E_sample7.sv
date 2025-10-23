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
localparam [1:0]
    IDLE      = 2'd0,
    S1_RED    = 2'd1,
    S3_GREEN  = 2'd2,
    S2_YELLOW = 2'd3;

// Timing parameters
localparam [7:0] RED_TIME    = 8'd10;
localparam [7:0] YELLOW_TIME = 8'd5;
localparam [7:0] GREEN_TIME  = 8'd60;
localparam [7:0] SHORT_GREEN = 8'd10;

reg [1:0] state, next_state;
reg [7:0] cnt, next_cnt;

reg p_red, p_yellow, p_green;

/////////////////////
// State & Counter //
/////////////////////

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state  <= IDLE;
        cnt    <= 8'd0;
        p_red  <= 1'b0;
        p_yellow <= 1'b0;
        p_green <= 1'b0;
    end else begin
        state <= next_state;
        cnt <= next_cnt;
        p_red <= (next_state == S1_RED);
        p_yellow <= (next_state == S2_YELLOW);
        p_green <= (next_state == S3_GREEN);
    end
end

//////////////////////
// Next state logic //
//////////////////////

always @(*) begin
    next_state = state;
    next_cnt = cnt;

    case(state)
        IDLE: begin
            // Initialize red immediately
            next_state = S1_RED;
            next_cnt = RED_TIME;
        end

        S1_RED: begin
            // Red active, count down
            if (cnt == 0) begin
                next_state = S3_GREEN;
                next_cnt = GREEN_TIME;
            end else begin
                next_cnt = cnt - 1;
            end
        end

        S3_GREEN: begin
            // Green active, count down or shorten if requested
            if (cnt == 0) begin
                next_state = S2_YELLOW;
                next_cnt = YELLOW_TIME;
            end else if (pass_request && cnt > SHORT_GREEN) begin
                next_cnt = SHORT_GREEN;
            end else begin
                next_cnt = cnt - 1;
            end
        end

        S2_YELLOW: begin
            // Yellow active, count down
            if (cnt == 0) begin
                next_state = S1_RED;
                next_cnt = RED_TIME;
            end else begin
                next_cnt = cnt - 1;
            end
        end

        default: begin
            next_state = IDLE;
            next_cnt = 0;
        end
    endcase
end

///////////////
// Outputs ///
///////////////

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        red <= 1'b0;
        yellow <= 1'b0;
        green <= 1'b0;
        clock <= 8'd0;
    end else begin
        red    <= p_red;
        yellow <= p_yellow;
        green  <= p_green;
        clock  <= cnt;
    end
end

endmodule