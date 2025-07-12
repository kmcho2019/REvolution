module traffic_light (
    input  wire       rst_n,
    input  wire       clk,
    input  wire       pass_request,
    output reg  [7:0] clock,
    output reg        red,
    output reg        yellow,
    output reg        green
);

    // State encoding
    typedef enum logic [1:0] {
        idle    = 2'd0,
        s1_red  = 2'd1,
        s2_yellow = 2'd2,
        s3_green = 2'd3
    } state_t;

    state_t state, next_state;
    reg [7:0] cnt_next;

    // Parameters for timing
    localparam RED_TIME    = 8'd10;
    localparam YELLOW_TIME = 8'd5;
    localparam GREEN_TIME  = 8'd60;
    localparam MIN_GREEN_TIME = 8'd10;

    // Next state and counter logic combinational
    always @(*) begin
        next_state = state;
        cnt_next = cnt;

        case(state)
            idle: begin
                // Immediately transition to red with red timer
                next_state = s1_red;
                cnt_next = RED_TIME;
            end
            s1_red: begin
                if (cnt == 0) begin
                    next_state = s3_green;
                    cnt_next = GREEN_TIME;
                end else begin
                    next_state = s1_red;
                    cnt_next = cnt - 1;
                end
            end
            s2_yellow: begin
                if (cnt == 0) begin
                    next_state = s1_red;
                    cnt_next = RED_TIME;
                end else begin
                    next_state = s2_yellow;
                    cnt_next = cnt - 1;
                end
            end
            s3_green: begin
                if (cnt == 0) begin
                    next_state = s2_yellow;
                    cnt_next = YELLOW_TIME;
                end else begin
                    // Pedestrian request: if pass_request asserted and remaining green time > 10, shorten
                    if (pass_request && (cnt > MIN_GREEN_TIME)) begin
                        cnt_next = MIN_GREEN_TIME;
                    end else begin
                        cnt_next = cnt - 1;
                    end
                    next_state = s3_green;
                end
            end
            default: begin
                next_state = idle;
                cnt_next = RED_TIME;
            end
        endcase
    end

    reg [7:0] cnt;

    // State and counter update sequential logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= idle;
            cnt <= RED_TIME;
        end else begin
            state <= next_state;
            cnt <= cnt_next;
        end
    end

    // Output logic: direct from state
    always @(*) begin
        // Default all off
        red = 1'b0;
        yellow = 1'b0;
        green = 1'b0;

        case(state)
            s1_red:    red = 1'b1;
            s2_yellow: yellow = 1'b1;
            s3_green:  green = 1'b1;
            default: ; // idle: all off
        endcase
    end

    // Output counter
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            clock <= 8'd0;
        else
            clock <= cnt;
    end

endmodule