module traffic_light (
    input wire rst_n,
    input wire clk,
    input wire pass_request,
    output reg [7:0] clock,
    output reg red,
    output reg yellow,
    output reg green
);

// State encoding
localparam IDLE      = 2'd0;
localparam RED       = 2'd1;
localparam YELLOW    = 2'd2;
localparam GREEN     = 2'd3;

// State durations in cycles
localparam RED_TIME    = 8'd10;
localparam YELLOW_TIME = 8'd5;
localparam GREEN_TIME  = 8'd60;
localparam SHORT_GREEN = 8'd10;

reg [1:0] state, next_state;
reg [7:0] timer, next_timer;
reg ped_shortened;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= RED;
        timer <= RED_TIME;
        ped_shortened <= 1'b0;
        red <= 1'b1;
        yellow <= 1'b0;
        green <= 1'b0;
        clock <= RED_TIME;
    end else begin
        state <= next_state;

        // Pedestrian shortening logic applied only on green phase and not yet shortened
        if (state == GREEN && pass_request && !ped_shortened && (timer > SHORT_GREEN)) begin
            timer <= SHORT_GREEN;
            ped_shortened <= 1'b1;
        end else begin
            timer <= next_timer;
            if (state != GREEN)
                ped_shortened <= 1'b0; // reset when leaving green
        end

        // Outputs registered based on current state
        case (next_state)
            RED: begin
                red <= 1'b1;
                yellow <= 1'b0;
                green <= 1'b0;
            end
            YELLOW: begin
                red <= 1'b0;
                yellow <= 1'b1;
                green <= 1'b0;
            end
            GREEN: begin
                red <= 1'b0;
                yellow <= 1'b0;
                green <= 1'b1;
            end
            default: begin
                red <= 1'b1;
                yellow <= 1'b0;
                green <= 1'b0;
            end
        endcase

        clock <= timer;
    end
end

// Next state and timer combinational logic
always @(*) begin
    next_state = state;

    if (timer == 0) begin
        case(state)
            RED: next_state = GREEN;
            GREEN: next_state = YELLOW;
            YELLOW: next_state = RED;
            default: next_state = RED;
        endcase
    end

    // Timer decrements if not zero
    if (timer != 0)
        next_timer = timer - 1;
    else
        next_timer = 0;
end

endmodule