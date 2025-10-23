module traffic_light (
    input  wire       rst_n,
    input  wire       clk,
    input  wire       pass_request,
    output reg  [6:0] clock,   // 7-bit timer suffices for max 60
    output wire       red,
    output wire       yellow,
    output wire       green
);

    // State encoding
    localparam IDLE      = 2'd0;
    localparam S1_RED    = 2'd1;
    localparam S2_YELLOW = 2'd2;
    localparam S3_GREEN  = 2'd3;

    // Timing constants
    localparam RED_TIME    = 7'd10;
    localparam YELLOW_TIME = 7'd5;
    localparam GREEN_TIME  = 7'd60;
    localparam GREEN_MIN   = 7'd10;

    reg [1:0] state, next_state;
    reg [6:0] timer, next_timer;
    reg       ped_shortened, next_ped_shortened;

    // Sequential logic: state, timer, ped_shortened update
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state         <= IDLE;
            timer         <= 0;
            ped_shortened <= 1'b0;
        end else begin
            state         <= next_state;
            timer         <= next_timer;
            ped_shortened <= next_ped_shortened;
        end
    end

    // Combinational next-state and timer logic with pedestrian shortening and clock gating
    always @(*) begin
        // Defaults
        next_state = state;
        next_timer = timer;
        next_ped_shortened = ped_shortened;

        case (state)
            IDLE: begin
                // Immediately transition to RED with RED_TIME timer
                next_state = S1_RED;
                next_timer = RED_TIME;
                next_ped_shortened = 1'b0;
            end

            S1_RED: begin
                if (timer == 0) begin
                    next_state = S3_GREEN;
                    next_timer = GREEN_TIME;
                    next_ped_shortened = 1'b0;
                end else if (timer != 0) begin
                    next_timer = timer - 1;
                end
            end

            S2_YELLOW: begin
                if (timer == 0) begin
                    next_state = S1_RED;
                    next_timer = RED_TIME;
                    next_ped_shortened = 1'b0;
                end else if (timer != 0) begin
                    next_timer = timer - 1;
                end
            end

            S3_GREEN: begin
                // Pedestrian button can shorten green time once per green phase if timer > GREEN_MIN
                if (pass_request && !ped_shortened && (timer > GREEN_MIN)) begin
                    next_timer = GREEN_MIN;
                    next_ped_shortened = 1'b1;
                end else if (timer == 0) begin
                    next_state = S2_YELLOW;
                    next_timer = YELLOW_TIME;
                    next_ped_shortened = 1'b0;
                end else if (timer != 0) begin
                    next_timer = timer - 1;
                end
            end

            default: begin
                next_state = IDLE;
                next_timer = 0;
                next_ped_shortened = 1'b0;
            end
        endcase
    end

    // Outputs driven combinationally from current state
    assign red    = (state == S1_RED);
    assign yellow = (state == S2_YELLOW);
    assign green  = (state == S3_GREEN);

    // Output current timer as clock value
    always @(*) begin
        clock = timer;
    end

endmodule