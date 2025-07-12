module traffic_light (
    input        rst_n,
    input        clk,
    input        pass_request,
    output [7:0] clock,
    output reg   red,
    output reg   yellow,
    output reg   green
);

    // State encoding
    typedef enum logic [1:0] {
        s1_red    = 2'b00,
        s3_green  = 2'b01,
        s2_yellow = 2'b10
    } state_t;

    localparam GREEN_TIME_DEFAULT  = 8'd60;
    localparam YELLOW_TIME         = 8'd5;
    localparam RED_TIME            = 8'd10;
    localparam GREEN_TIME_MIN      = 8'd10;

    state_t state, next_state;
    reg [7:0] cnt, next_cnt;
    reg pass_request_sync0, pass_request_sync1;

    // Synchronize pass_request to clk domain to avoid glitches
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            pass_request_sync0 <= 1'b0;
            pass_request_sync1 <= 1'b0;
        end else begin
            pass_request_sync0 <= pass_request;
            pass_request_sync1 <= pass_request_sync0;
        end
    end

    wire pass_request_sync = pass_request_sync1;

    // State register
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            state <= s1_red;
        else
            state <= next_state;
    end

    // Counter register
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            cnt <= RED_TIME;
        else
            cnt <= next_cnt;
    end

    // Next state and next counter logic
    always @(*) begin
        // Default assignments
        next_state = state;
        next_cnt   = cnt;

        case (state)
            s1_red: begin
                if (cnt == 0) begin
                    next_state = s3_green;
                    next_cnt   = GREEN_TIME_DEFAULT;
                end else begin
                    next_cnt = cnt - 1;
                end
            end

            s3_green: begin
                // Shorten green if pass_request asserted and remaining time > GREEN_TIME_MIN
                if (pass_request_sync && (cnt > GREEN_TIME_MIN))
                    next_cnt = GREEN_TIME_MIN;
                else if (cnt == 0) begin
                    next_state = s2_yellow;
                    next_cnt   = YELLOW_TIME;
                end else begin
                    next_cnt = cnt - 1;
                end
            end

            s2_yellow: begin
                if (cnt == 0) begin
                    next_state = s1_red;
                    next_cnt   = RED_TIME;
                end else begin
                    next_cnt = cnt - 1;
                end
            end

            default: begin
                next_state = s1_red;
                next_cnt   = RED_TIME;
            end
        endcase
    end

    // Output logic separated from state transition for clarity
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            red    <= 1'b1;
            yellow <= 1'b0;
            green  <= 1'b0;
        end else begin
            case (next_state)
                s1_red: begin
                    red    <= 1'b1;
                    yellow <= 1'b0;
                    green  <= 1'b0;
                end
                s3_green: begin
                    red    <= 1'b0;
                    yellow <= 1'b0;
                    green  <= 1'b1;
                end
                s2_yellow: begin
                    red    <= 1'b0;
                    yellow <= 1'b1;
                    green  <= 1'b0;
                end
                default: begin
                    red    <= 1'b1;
                    yellow <= 1'b0;
                    green  <= 1'b0;
                end
            endcase
        end
    end

    assign clock = cnt;

endmodule