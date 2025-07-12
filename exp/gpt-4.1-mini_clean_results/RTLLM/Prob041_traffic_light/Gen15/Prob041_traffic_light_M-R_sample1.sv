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
        IDLE     = 2'd0,
        S1_RED   = 2'd1,
        S2_YELLOW= 2'd2,
        S3_GREEN = 2'd3
    } state_t;

    state_t state, next_state;

    localparam logic [7:0] RED_TIME    = 8'd10;
    localparam logic [7:0] YELLOW_TIME = 8'd5;
    localparam logic [7:0] GREEN_TIME  = 8'd60;
    localparam logic [7:0] GREEN_MIN   = 8'd10;

    reg [7:0] timer, next_timer;

    // Combinational next timer logic
    wire timer_zero = (timer == 0);

    // Next state logic
    always @(*) begin
        next_state = state;
        case(state)
            IDLE:     next_state = S1_RED;
            S1_RED:   if(timer_zero) next_state = S3_GREEN;
            S2_YELLOW:if(timer_zero) next_state = S1_RED;
            S3_GREEN: if(timer_zero) next_state = S2_YELLOW;
            default:  next_state = IDLE;
        endcase
    end

    // Next timer combinational logic
    always @(*) begin
        next_timer = timer;
        case(state)
            IDLE:       next_timer = RED_TIME;
            S1_RED:     if(timer_zero) next_timer = GREEN_TIME; else next_timer = timer - 1;
            S2_YELLOW:  if(timer_zero) next_timer = RED_TIME; else next_timer = timer - 1;
            S3_GREEN: begin
                // Pedestrian button shortens timer if above GREEN_MIN
                if (pass_request && (timer > GREEN_MIN)) begin
                    next_timer = GREEN_MIN;
                end else if (timer_zero) begin
                    next_timer = YELLOW_TIME;
                end else begin
                    next_timer = timer - 1;
                end
            end
            default:    next_timer = 0;
        endcase
    end

    // State and timer update
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= IDLE;
            timer <= 0;
        end else begin
            state <= next_state;
            timer <= next_timer;
        end
    end

    // Outputs updated synchronously from state
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            red    <= 1'b0;
            yellow <= 1'b0;
            green  <= 1'b0;
        end else begin
            case(state)
                S1_RED: begin red <= 1; yellow <= 0; green <= 0; end
                S2_YELLOW: begin red <= 0; yellow <= 1; green <= 0; end
                S3_GREEN: begin red <= 0; yellow <= 0; green <= 1; end
                default:  begin red <= 0; yellow <= 0; green <= 0; end
            endcase
        end
    end

    // Clock output is current timer
    always @(*) begin
        clock = timer;
    end

endmodule