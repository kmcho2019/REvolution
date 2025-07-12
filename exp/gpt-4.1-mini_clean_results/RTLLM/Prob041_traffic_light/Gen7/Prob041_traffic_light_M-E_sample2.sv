module traffic_light (
    input        rst_n,
    input        clk,
    input        pass_request,
    output reg [7:0] clock,
    output reg   red,
    output reg   yellow,
    output reg   green
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
    reg [7:0] counter, next_counter;
    reg [7:0] max_count, next_max_count;

    // State transition and counter logic
    always @(*) begin
        // Default assignments
        next_state = state;
        next_counter = counter;
        next_max_count = max_count;

        case(state)
            S_RED: begin
                // Counting up to max_count
                if(counter == max_count) begin
                    next_state = S_GREEN;
                    next_counter = 8'd0;
                    next_max_count = GREEN_TIME;
                end else begin
                    next_counter = counter + 1;
                end
            end

            S_GREEN: begin
                // If pass_request and remaining time > 10, shorten time to 10
                // remaining time = max_count - counter
                if(pass_request && (max_count - counter > GREEN_SHORT)) begin
                    next_max_count = counter + GREEN_SHORT;
                end

                if(counter == max_count) begin
                    next_state = S_YELLOW;
                    next_counter = 8'd0;
                    next_max_count = YELLOW_TIME;
                end else begin
                    next_counter = counter + 1;
                end
            end

            S_YELLOW: begin
                if(counter == max_count) begin
                    next_state = S_RED;
                    next_counter = 8'd0;
                    next_max_count = RED_TIME;
                end else begin
                    next_counter = counter + 1;
                end
            end

            default: begin
                next_state = S_RED;
                next_counter = 8'd0;
                next_max_count = RED_TIME;
            end
        endcase
    end

    // Sequential logic to update state, counter, and max_count
    always @(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            state <= S_RED;
            counter <= 8'd0;
            max_count <= RED_TIME;
            // Outputs reset
            red <= 1'b0;
            yellow <= 1'b0;
            green <= 1'b0;
            clock <= 8'd0;
        end else begin
            state <= next_state;
            counter <= next_counter;
            max_count <= next_max_count;

            // Output logic: set active light for vehicle lane
            red <= (next_state == S_RED);
            yellow <= (next_state == S_YELLOW);
            green <= (next_state == S_GREEN);

            clock <= next_max_count - next_counter; // Remaining time countdown for output
        end
    end

endmodule