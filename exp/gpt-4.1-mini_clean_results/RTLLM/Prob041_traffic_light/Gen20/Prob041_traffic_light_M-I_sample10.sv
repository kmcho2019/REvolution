module traffic_light (
    input            rst_n,
    input            clk,
    input            pass_request,
    output reg [5:0] clock,
    output           red,
    output           yellow,
    output           green
);

    // Timing parameters (6 bits sufficient for max 60)
    localparam RED_TIME     = 6'd10;
    localparam YELLOW_TIME  = 6'd5;
    localparam GREEN_TIME   = 6'd60;
    localparam GREEN_SHORT  = 6'd10;

    // One-hot state encoding for simplicity and faster combinational logic
    localparam RED    = 3'b001;
    localparam GREEN  = 3'b010;
    localparam YELLOW = 3'b100;

    reg [2:0] state, next_state;
    reg [5:0] cnt, next_cnt;
    reg       ped_shortened, next_ped_shortened;

    // Outputs combinationally derived from state
    assign red    = state[0];
    assign green  = state[1];
    assign yellow = state[2];

    always @(posedge clk) begin
        if (!rst_n) begin
            state         <= RED;
            cnt           <= RED_TIME;
            ped_shortened <= 1'b0;
        end else begin
            state         <= next_state;
            cnt           <= next_cnt;
            ped_shortened <= next_ped_shortened;
        end
    end

    always @(*) begin
        // Defaults: hold current values
        next_state         = state;
        next_cnt           = cnt;
        next_ped_shortened = ped_shortened;

        case (state)
            RED: begin
                next_ped_shortened = 1'b0; // Reset ped_shortened on RED
                if (cnt == 0) begin
                    next_state = GREEN;
                    next_cnt   = GREEN_TIME;
                    // ped_shortened cleared on new GREEN state below
                    next_ped_shortened = 1'b0;
                end else begin
                    if (cnt != 0)
                        next_cnt = cnt - 1;
                end
            end

            GREEN: begin
                // Pedestrian request shortens green once, if remaining time > 10
                if (pass_request && !ped_shortened && (cnt > GREEN_SHORT)) begin
                    next_cnt           = GREEN_SHORT;
                    next_ped_shortened = 1'b1;
                end else if (cnt == 0) begin
                    next_state         = YELLOW;
                    next_cnt           = YELLOW_TIME;
                    next_ped_shortened = 1'b0;
                end else if (cnt != 0) begin
                    next_cnt = cnt - 1;
                end
            end

            YELLOW: begin
                next_ped_shortened = 1'b0; // Reset ped_shortened on YELLOW
                if (cnt == 0) begin
                    next_state = RED;
                    next_cnt   = RED_TIME;
                end else if (cnt != 0) begin
                    next_cnt = cnt - 1;
                end
            end

            default: begin
                next_state         = RED;
                next_cnt           = RED_TIME;
                next_ped_shortened = 1'b0;
            end
        endcase
    end

    // Drive output clock from counter
    always @(*) begin
        clock = cnt;
    end

endmodule