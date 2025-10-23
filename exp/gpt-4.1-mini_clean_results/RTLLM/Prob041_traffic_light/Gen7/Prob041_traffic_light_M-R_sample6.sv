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
    IDLE    = 2'd0,
    S1_RED  = 2'd1,
    S2_YELLOW = 2'd2,
    S3_GREEN  = 2'd3;

// Timing parameters
localparam [7:0]
    RED_TIME    = 8'd10,
    YELLOW_TIME = 8'd5,
    GREEN_TIME  = 8'd60,
    SHORT_GREEN = 8'd10;

reg [1:0] state, next_state;
reg [7:0] cnt, next_cnt;

// Sequential logic: state and counter update
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= IDLE;
        cnt   <= 8'd0;
    end else begin
        state <= next_state;
        cnt   <= next_cnt;
    end
end

// Combinational logic: next state and next counter
always @(*) begin
    // Default assignments to hold current values
    next_state = state;
    next_cnt = cnt;

    case(state)
        IDLE: begin
            // Immediately transition to red state with counter loaded
            next_state = S1_RED;
            next_cnt = RED_TIME;
        end

        S1_RED: begin
            // Red light active
            if (cnt == 0) begin
                next_state = S3_GREEN;
                next_cnt = GREEN_TIME;
            end else begin
                next_cnt = cnt - 1;
            end
        end

        S3_GREEN: begin
            // Green light active
            if (pass_request && (cnt > SHORT_GREEN)) begin
                // Shorten green time to 10 if pass_request and remaining green > 10
                next_cnt = SHORT_GREEN;
            end else if (cnt == 0) begin
                next_state = S2_YELLOW;
                next_cnt = YELLOW_TIME;
            end else if (cnt > 0) begin
                next_cnt = cnt - 1;
            end
        end

        S2_YELLOW: begin
            // Yellow light active
            if (cnt == 0) begin
                next_state = S1_RED;
                next_cnt = RED_TIME;
            end else begin
                next_cnt = cnt - 1;
            end
        end

        default: begin
            // Safety fallback
            next_state = IDLE;
            next_cnt = 8'd0;
        end
    endcase
end

// Output logic: outputs depend on state
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        red    <= 1'b0;
        yellow <= 1'b0;
        green  <= 1'b0;
        clock  <= 8'd0;
    end else begin
        red    <= (state == S1_RED);
        yellow <= (state == S2_YELLOW);
        green  <= (state == S3_GREEN);
        clock  <= cnt;
    end
end

endmodule