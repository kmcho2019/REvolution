module traffic_light (
    input  wire        rst_n,
    input  wire        clk,
    input  wire        pass_request,
    output reg  [7:0]  clock,
    output reg         red,
    output reg         yellow,
    output reg         green
);

    // State encoding
    localparam IDLE      = 2'd0;
    localparam RED       = 2'd1;
    localparam YELLOW    = 2'd2;
    localparam GREEN     = 2'd3;

    // Timing parameters (in clock cycles)
    localparam RED_TIME    = 8'd10;
    localparam YELLOW_TIME = 8'd5;
    localparam GREEN_TIME  = 8'd60;
    localparam GREEN_SHORT = 8'd10;

    reg [1:0] state, next_state;
    reg [7:0] timer, next_timer;
    reg       ped_shortened, next_ped_shortened;

    // Sequential logic: state, timer and pedestrian shortened flag update
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state          <= RED;
            timer          <= RED_TIME;
            ped_shortened  <= 1'b0;
            red            <= 1'b1;
            yellow         <= 1'b0;
            green          <= 1'b0;
            clock          <= RED_TIME;
        end else begin
            state          <= next_state;
            timer          <= next_timer;
            ped_shortened  <= next_ped_shortened;

            // Registered outputs reflecting current state
            red            <= (next_state == RED);
            yellow         <= (next_state == YELLOW);
            green          <= (next_state == GREEN);
            clock          <= next_timer;
        end
    end

    // Combinational logic: next state, timer, and ped_shortened flag
    always @(*) begin
        // Default assignments: hold state, decrement timer if nonzero
        next_state         = state;
        next_timer         = (timer != 0) ? (timer - 1) : 8'd0;
        next_ped_shortened = ped_shortened;

        case(state)
            RED: begin
                if (timer == 0) begin
                    next_state = GREEN;
                    next_timer = GREEN_TIME;
                    next_ped_shortened = 1'b0; // Clear shortening flag on green entry
                end
            end

            GREEN: begin
                // If pedestrian request is asserted, shortening not yet applied,
                // and timer > GREEN_SHORT, clamp timer to GREEN_SHORT
                if (pass_request && !ped_shortened && (timer > GREEN_SHORT)) begin
                    next_timer = GREEN_SHORT;
                    next_ped_shortened = 1'b1;
                    next_state = GREEN;
                end else if (timer == 0) begin
                    next_state = YELLOW;
                    next_timer = YELLOW_TIME;
                    next_ped_shortened = 1'b0;
                end
            end

            YELLOW: begin
                if (timer == 0) begin
                    next_state = RED;
                    next_timer = RED_TIME;
                    next_ped_shortened = 1'b0;
                end
            end

            default: begin
                next_state = RED;
                next_timer = RED_TIME;
                next_ped_shortened = 1'b0;
            end
        endcase
    end

endmodule