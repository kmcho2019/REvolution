module traffic_light (
    input         rst_n,
    input         clk,
    input         pass_request,
    output reg [7:0] clock,
    output reg    red,
    output reg    yellow,
    output reg    green
);

    // Timing parameters
    localparam [7:0] RED_TIME    = 8'd10;
    localparam [7:0] YELLOW_TIME = 8'd5;
    localparam [7:0] GREEN_TIME  = 8'd60;
    localparam [7:0] GREEN_SHORT = 8'd10;

    // State encoding
    typedef enum reg [1:0] {
        RED    = 2'd0,
        GREEN  = 2'd1,
        YELLOW = 2'd2
    } state_t;

    reg [7:0] cnt, next_cnt;
    state_t state, next_state;

    reg ped_shortened, next_ped_shortened;

    // Combinational logic for next state and counter
    always @(*) begin
        next_state = state;
        next_cnt = cnt;
        // Default hold flag, update separately
        next_ped_shortened = ped_shortened;

        case (state)
            RED: begin
                if (cnt == 0) begin
                    next_state = GREEN;
                    next_cnt = GREEN_TIME;
                    // ped_shortened reset handled in sequential block
                end else begin
                    next_cnt = cnt - 1;
                end
            end
            GREEN: begin
                // If pass_request active and not shortened and remaining > 10, shorten
                if (pass_request && !ped_shortened && (cnt > GREEN_SHORT)) begin
                    next_cnt = GREEN_SHORT;
                    // ped_shortened flag update in sequential block
                end else if (cnt == 0) begin
                    next_state = YELLOW;
                    next_cnt = YELLOW_TIME;
                    // ped_shortened reset handled sequentially
                end else begin
                    next_cnt = cnt - 1;
                end
            end
            YELLOW: begin
                if (cnt == 0) begin
                    next_state = RED;
                    next_cnt = RED_TIME;
                    // ped_shortened reset handled sequentially
                end else begin
                    next_cnt = cnt - 1;
                end
            end
            default: begin
                next_state = RED;
                next_cnt = RED_TIME;
                next_ped_shortened = 1'b0;
            end
        endcase
    end

    // Sequential logic for state, counter, ped_shortened flag and outputs
    always @(posedge clk) begin
        if (!rst_n) begin
            state <= RED;
            cnt <= RED_TIME;
            ped_shortened <= 1'b0;
            red <= 1'b1;
            yellow <= 1'b0;
            green <= 1'b0;
            clock <= RED_TIME;
        end else begin
            state <= next_state;
            cnt <= next_cnt;
            clock <= next_cnt;

            // Update ped_shortened flag only in sequential logic
            // Set ped_shortened when we shorten green time by pass_request
            if (state == GREEN && pass_request && !ped_shortened && (cnt > GREEN_SHORT)) begin
                ped_shortened <= 1'b1;
            end
            // Reset ped_shortened when entering or leaving GREEN state
            else if (state != GREEN) begin
                ped_shortened <= 1'b0;
            end

            // Update outputs registered from current state for glitch free outputs
            red <= (next_state == RED);
            yellow <= (next_state == YELLOW);
            green <= (next_state == GREEN);
        end
    end

endmodule