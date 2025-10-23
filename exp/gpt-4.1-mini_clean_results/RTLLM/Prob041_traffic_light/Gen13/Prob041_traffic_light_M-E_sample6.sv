module traffic_light (
    input  wire       rst_n,
    input  wire       clk,
    input  wire       pass_request,
    output reg  [7:0] clock,
    output reg        red,
    output reg        yellow,
    output reg        green
);

    // State encoding for FSM
    typedef enum reg [1:0] {
        IDLE   = 2'b00,
        RED    = 2'b01,
        GREEN  = 2'b10,
        YELLOW = 2'b11
    } state_t;

    // Timing parameters
    localparam [7:0] RED_TIME    = 8'd10;
    localparam [7:0] YELLOW_TIME = 8'd5;
    localparam [7:0] GREEN_TIME  = 8'd60;
    localparam [7:0] SHORT_GREEN = 8'd10;

    reg [7:0] counter;
    state_t state, next_state;
    reg [7:0] reload_val;

    // State register with synchronous reset
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= IDLE;
            counter <= 8'd0;
        end else begin
            state <= next_state;
            if (counter == 0) 
                counter <= reload_val;
            else
                counter <= counter - 1;
        end
    end

    // Next state and reload value logic
    always @(*) begin
        next_state = state;
        reload_val = 8'd0; // Default to zero to avoid latches

        case (state)
            IDLE: begin
                next_state = RED;
                reload_val = RED_TIME;
            end

            RED: begin
                reload_val = RED_TIME;
                if (counter == 0)
                    next_state = GREEN;
            end

            GREEN: begin
                // Default reload is full green time
                reload_val = GREEN_TIME;
                if (pass_request && (counter > SHORT_GREEN))
                    // shorten green time if pedestrian pressed and time left > 10
                    reload_val = SHORT_GREEN;
                else
                    reload_val = counter; // maintain current counter if not shortened

                if (counter == 0)
                    next_state = YELLOW;
            end

            YELLOW: begin
                reload_val = YELLOW_TIME;
                if (counter == 0)
                    next_state = RED;
            end

            default: begin
                next_state = IDLE;
                reload_val = 8'd0;
            end
        endcase
    end

    // Output logic based solely on state
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

    // Output the current counter value
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            clock <= 8'd0;
        end else begin
            clock <= counter;
        end
    end

endmodule