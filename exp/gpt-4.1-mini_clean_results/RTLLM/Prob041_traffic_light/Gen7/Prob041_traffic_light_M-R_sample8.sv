module traffic_light (
    input  wire       rst_n,
    input  wire       clk,
    input  wire       pass_request,
    output wire [7:0] clock,
    output wire       red,
    output wire       yellow,
    output wire       green
);

    // State encoding
    typedef enum logic [1:0] {
        RED    = 2'd0,
        GREEN  = 2'd1,
        YELLOW = 2'd2
    } state_t;

    // Timing constants
    localparam [7:0] RED_TIME    = 8'd10;
    localparam [7:0] YELLOW_TIME = 8'd5;
    localparam [7:0] GREEN_TIME  = 8'd60;
    localparam [7:0] SHORT_GREEN = 8'd10;

    state_t state, state_next;
    reg [7:0] timer;
    reg green_shortened; // Flag to indicate green has been shortened this cycle

    // State and timer update block
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= RED;
            timer <= RED_TIME;
            green_shortened <= 1'b0;
        end else begin
            // State transition
            if (timer == 0) begin
                case (state)
                    RED:    state <= GREEN;
                    GREEN:  state <= YELLOW;
                    YELLOW: state <= RED;
                    default: state <= RED;
                endcase

                // Reset green_shortened on new green state
                green_shortened <= 1'b0;

                // Reload timer on state change
                case (state)
                    RED:    timer <= GREEN_TIME;   // Because next state after RED is GREEN
                    GREEN:  timer <= YELLOW_TIME;  // Next after GREEN is YELLOW
                    YELLOW: timer <= RED_TIME;     // Next after YELLOW is RED
                    default: timer <= RED_TIME;
                endcase
            end else begin
                // In green state, shorten timer if pass_request asserted and not yet shortened
                if (state == GREEN && pass_request && !green_shortened && timer > SHORT_GREEN) begin
                    timer <= SHORT_GREEN;
                    green_shortened <= 1'b1;
                end else if (timer != 0) begin
                    timer <= timer - 1;
                end
            end
        end
    end

    // Outputs: combinational from state
    assign red    = (state == RED);
    assign yellow = (state == YELLOW);
    assign green  = (state == GREEN);

    // Output clock is current timer value
    assign clock = timer;

endmodule