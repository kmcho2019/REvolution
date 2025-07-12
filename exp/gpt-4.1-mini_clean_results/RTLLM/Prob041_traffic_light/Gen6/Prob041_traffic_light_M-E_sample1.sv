module traffic_light(
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
        IDLE   = 2'd0,
        RED    = 2'd1,
        GREEN  = 2'd2,
        YELLOW = 2'd3
    } state_t;

    localparam [7:0] RED_TIME    = 8'd10;
    localparam [7:0] YELLOW_TIME = 8'd5;
    localparam [7:0] GREEN_TIME  = 8'd60;
    localparam [7:0] MIN_GREEN   = 8'd10;

    state_t current_state, next_state;
    reg [7:0] counter, next_counter;

    // State and counter sequential logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            current_state <= IDLE;
            counter       <= 8'd0;
        end else begin
            current_state <= next_state;
            counter       <= next_counter;
        end
    end

    // Next state and counter logic
    always @(*) begin
        // Defaults
        next_state   = current_state;
        next_counter = counter;

        case (current_state)
            IDLE: begin
                // Immediately go to RED with counter loaded
                next_state   = RED;
                next_counter = RED_TIME;
            end

            RED: begin
                if (counter == 0) begin
                    next_state   = GREEN;
                    next_counter = GREEN_TIME;
                end else begin
                    next_counter = counter - 1;
                end
            end

            GREEN: begin
                // If pass_request asserted and counter > MIN_GREEN, clamp to MIN_GREEN
                if (pass_request && (counter > MIN_GREEN))
                    next_counter = MIN_GREEN;
                else if (counter == 0) begin
                    next_state   = YELLOW;
                    next_counter = YELLOW_TIME;
                end else begin
                    next_counter = counter - 1;
                end
            end

            YELLOW: begin
                if (counter == 0) begin
                    next_state   = RED;
                    next_counter = RED_TIME;
                end else begin
                    next_counter = counter - 1;
                end
            end

            default: begin
                next_state   = IDLE;
                next_counter = 8'd0;
            end
        endcase
    end

    // Outputs driven directly from state
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            red    <= 1'b0;
            yellow <= 1'b0;
            green  <= 1'b0;
            clock  <= 8'd0;
        end else begin
            red    <= (current_state == RED);
            yellow <= (current_state == YELLOW);
            green  <= (current_state == GREEN);
            clock  <= counter;
        end
    end

endmodule