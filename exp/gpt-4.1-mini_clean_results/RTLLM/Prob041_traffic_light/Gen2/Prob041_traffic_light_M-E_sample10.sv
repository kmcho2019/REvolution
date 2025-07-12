module traffic_light(
    input          rst_n,
    input          clk,
    input          pass_request,
    output [7:0]   clock,
    output reg     red,
    output reg     yellow,
    output reg     green
);

    // State encoding (one-hot style for clarity)
    typedef enum logic [1:0] {
        IDLE   = 2'b00,
        RED    = 2'b01,
        GREEN  = 2'b10,
        YELLOW = 2'b11
    } state_t;

    state_t state, next_state;

    reg [7:0] cnt, next_cnt;

    // State register and counter update
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= IDLE;
            cnt <= 8'd10;
        end else begin
            state <= next_state;
            cnt <= next_cnt;
        end
    end

    // Next state and counter combinational logic
    always @(*) begin
        // Default assignments
        next_state = state;
        next_cnt = cnt;

        case (state)
            IDLE: begin
                // Immediately move to RED state with 10 cycles
                next_state = RED;
                next_cnt = 8'd10;
            end

            RED: begin
                if (cnt == 0) begin
                    next_state = GREEN;
                    next_cnt = 8'd60; // Start green cycle
                end else begin
                    next_cnt = cnt - 1;
                end
            end

            GREEN: begin
                if (cnt == 0) begin
                    next_state = YELLOW;
                    next_cnt = 8'd5;
                end else if (pass_request && (cnt > 8'd10)) begin
                    // If pedestrian presses button and time left > 10, shorten to 10
                    next_cnt = 8'd10;
                end else begin
                    next_cnt = cnt - 1;
                end
            end

            YELLOW: begin
                if (cnt == 0) begin
                    next_state = RED;
                    next_cnt = 8'd10;
                end else begin
                    next_cnt = cnt - 1;
                end
            end

            default: begin
                next_state = IDLE;
                next_cnt = 8'd10;
            end
        endcase
    end

    // Output logic - Moore outputs based on current state
    always @(*) begin
        red = 1'b0;
        yellow = 1'b0;
        green = 1'b0;

        case (state)
            RED: red = 1'b1;
            GREEN: green = 1'b1;
            YELLOW: yellow = 1'b1;
            default: begin
                red = 1'b0;
                yellow = 1'b0;
                green = 1'b0;
            end
        endcase
    end

    assign clock = cnt;

endmodule