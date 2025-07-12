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
    typedef enum reg [1:0] {
        S_RED    = 2'd0,
        S_GREEN  = 2'd1,
        S_YELLOW = 2'd2
    } state_t;

    // Timing parameters
    localparam RED_TIME    = 8'd10;
    localparam YELLOW_TIME = 8'd5;
    localparam GREEN_TIME  = 8'd60;
    localparam GREEN_SHORT = 8'd10;

    reg [1:0] state, next_state;
    reg [7:0] timer, next_timer;
    reg       shortened_flag, next_shortened_flag;

    // Sequential logic: state, timer, and shortened_flag update
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state          <= S_RED;
            timer          <= RED_TIME;
            shortened_flag <= 1'b0;
            red            <= 1'b1;
            yellow         <= 1'b0;
            green          <= 1'b0;
            clock          <= RED_TIME;
        end else begin
            state          <= next_state;
            timer          <= next_timer;
            shortened_flag <= next_shortened_flag;

            // Outputs registered from current state
            red    <= (next_state == S_RED);
            yellow <= (next_state == S_YELLOW);
            green  <= (next_state == S_GREEN);
            clock  <= next_timer;
        end
    end

    // Combinational logic: determine next state, timer, shortened_flag
    always @(*) begin
        next_state          = state;
        next_timer          = timer;
        next_shortened_flag = shortened_flag;

        if (timer == 0) begin
            // State transitions when timer reaches zero
            case (state)
                S_RED: begin
                    next_state = S_GREEN;
                    next_timer = GREEN_TIME;
                    next_shortened_flag = 1'b0; // reset flag on green start
                end
                S_GREEN: begin
                    next_state = S_YELLOW;
                    next_timer = YELLOW_TIME;
                    next_shortened_flag = 1'b0; // reset flag for next green cycle
                end
                S_YELLOW: begin
                    next_state = S_RED;
                    next_timer = RED_TIME;
                    next_shortened_flag = 1'b0;
                end
                default: begin
                    next_state = S_RED;
                    next_timer = RED_TIME;
                    next_shortened_flag = 1'b0;
                end
            endcase
        end else begin
            // Timer counting down
            if (state == S_GREEN) begin
                // Check pass_request and shorten green time if conditions met
                if (pass_request && !shortened_flag && (timer > GREEN_SHORT)) begin
                    next_timer = GREEN_SHORT;
                    next_shortened_flag = 1'b1;
                end else begin
                    next_timer = timer - 1;
                end
            end else begin
                next_timer = timer - 1;
                next_shortened_flag = 1'b0; // clear in non-green states as safeguard
            end
        end
    end

endmodule