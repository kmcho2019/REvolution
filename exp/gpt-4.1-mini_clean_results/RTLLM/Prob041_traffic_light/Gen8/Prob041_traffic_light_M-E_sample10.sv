module traffic_light (
    input  wire       rst_n,
    input  wire       clk,
    input  wire       pass_request,
    output wire [7:0] clock,
    output reg        red,
    output reg        yellow,
    output reg        green
);

    // States encoding: 3 bits:
    // bit2: red, bit1: yellow, bit0: green for direct output decoding
    localparam [2:0]
        IDLE   = 3'b000,
        RED    = 3'b100,
        YELLOW = 3'b010,
        GREEN  = 3'b001;

    localparam [7:0]
        RED_TIME    = 8'd10,
        YELLOW_TIME = 8'd5,
        GREEN_TIME  = 8'd60,
        SHORT_GREEN = 8'd10;

    reg [2:0] state, next_state;
    reg [7:0] timer, next_timer;

    // Output assignments based on current state encoding bits
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            red    <= 1'b0;
            yellow <= 1'b0;
            green  <= 1'b0;
        end else begin
            red    <= state[2];
            yellow <= state[1];
            green  <= state[0];
        end
    end

    // Main synchronous FSM and timer logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= IDLE;
            timer <= 8'd0;
        end else begin
            state <= next_state;
            timer <= next_timer;
        end
    end

    // Combinational logic for next state and timer
    always @(*) begin
        // Default assignments
        next_state = state;
        next_timer = timer;

        case (state)
            IDLE: begin
                // Initialize immediately to RED with timer loaded
                next_state = RED;
                next_timer = RED_TIME;
            end

            RED: begin
                if (timer == 0) begin
                    next_state = GREEN;
                    next_timer = GREEN_TIME;
                end else begin
                    next_timer = timer - 1;
                end
            end

            GREEN: begin
                // If pedestrian requests pass and timer > SHORT_GREEN, shorten timer
                if (pass_request && (timer > SHORT_GREEN)) begin
                    next_timer = SHORT_GREEN;
                end else if (timer == 0) begin
                    next_state = YELLOW;
                    next_timer = YELLOW_TIME;
                end else begin
                    next_timer = timer - 1;
                end
            end

            YELLOW: begin
                if (timer == 0) begin
                    next_state = RED;
                    next_timer = RED_TIME;
                end else begin
                    next_timer = timer - 1;
                end
            end

            default: begin
                next_state = RED;
                next_timer = RED_TIME;
            end
        endcase
    end

    assign clock = timer;

endmodule