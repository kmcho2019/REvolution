module traffic_light (
    input  wire       rst_n,
    input  wire       clk,
    input  wire       pass_request,
    output reg  [7:0] clock,
    output reg        red,
    output reg        yellow,
    output reg        green
);

    // State definitions
    typedef enum reg [1:0] {
        IDLE   = 2'b00,
        RED    = 2'b01,
        GREEN  = 2'b10,
        YELLOW = 2'b11
    } state_t;

    state_t state, next_state;

    // Timing constants
    localparam [7:0] RED_TIME    = 8'd10;
    localparam [7:0] YELLOW_TIME = 8'd5;
    localparam [7:0] GREEN_TIME  = 8'd60;
    localparam [7:0] GREEN_MIN   = 8'd10;

    reg [7:0] counter, next_counter;

    // State transition and next counter logic combinational
    always @(*) begin
        // Default assignments
        next_state   = state;
        next_counter = counter;

        case (state)
            IDLE: begin
                // On reset or startup, move to RED immediately
                next_state = RED;
                next_counter = RED_TIME;
            end

            RED: begin
                if (counter == 0) begin
                    next_state = GREEN;
                    next_counter = GREEN_TIME;
                end else begin
                    next_counter = counter - 1;
                end
            end

            GREEN: begin
                // Pedestrian button shortens green timer if remaining > 10
                if (pass_request && (counter > GREEN_MIN)) begin
                    next_counter = GREEN_MIN;
                end else if (counter == 0) begin
                    next_state = YELLOW;
                    next_counter = YELLOW_TIME;
                end else begin
                    next_counter = counter - 1;
                end
            end

            YELLOW: begin
                if (counter == 0) begin
                    next_state = RED;
                    next_counter = RED_TIME;
                end else begin
                    next_counter = counter - 1;
                end
            end

            default: begin
                next_state = IDLE;
                next_counter = 0;
            end
        endcase
    end

    // Sequential logic for state and counter update
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state   <= IDLE;
            counter <= 0;
        end else begin
            state   <= next_state;
            counter <= next_counter;
        end
    end

    // Outputs derived directly from current state
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            red    <= 1'b0;
            yellow <= 1'b0;
            green  <= 1'b0;
        end else begin
            red    <= (state == RED);
            yellow <= (state == YELLOW);
            green  <= (state == GREEN);
        end
    end

    // Drive clock output with current counter value
    always @(*) begin
        clock = counter;
    end

endmodule