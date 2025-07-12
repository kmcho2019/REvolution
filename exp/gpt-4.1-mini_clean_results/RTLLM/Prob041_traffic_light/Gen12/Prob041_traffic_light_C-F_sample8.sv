module traffic_light (
    input  wire      rst_n,
    input  wire      clk,
    input  wire      pass_request,
    output reg [6:0] clock,
    output reg       red,
    output reg       yellow,
    output reg       green
);

// State encoding
localparam IDLE   = 2'd0; // Not used in normal FSM, kept for clarity
localparam RED    = 2'd1;
localparam YELLOW = 2'd2;
localparam GREEN  = 2'd3;

// Timing parameters (7-bit as max is 60)
localparam RED_TIME    = 7'd10;
localparam YELLOW_TIME = 7'd5;
localparam GREEN_TIME  = 7'd60;
localparam SHORT_GREEN = 7'd10;

reg [1:0] state;
reg [6:0] timer;
reg       ped_shortened;

// Timer enable to minimize toggling when timer is zero
wire timer_en = (timer != 0);

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state         <= RED;
        timer         <= RED_TIME;
        ped_shortened <= 1'b0;
    end else begin
        case(state)
            RED: begin
                // Decrement timer if enabled
                if (timer_en)
                    timer <= timer - 1;
                else begin
                    // Transition to GREEN when timer reaches zero
                    state <= GREEN;
                    timer <= GREEN_TIME;
                    ped_shortened <= 1'b0; // Reset shortening flag at green start
                end
            end

            GREEN: begin
                // Apply pedestrian shortening once per green phase if conditions met
                if (pass_request && !ped_shortened && (timer > SHORT_GREEN)) begin
                    timer <= SHORT_GREEN;
                    ped_shortened <= 1'b1;
                end else if (timer_en) begin
                    timer <= timer - 1;
                end else begin
                    // Timer reached zero, move to YELLOW
                    state <= YELLOW;
                    timer <= YELLOW_TIME;
                    ped_shortened <= 1'b0; // Reset flag on leaving green
                end
            end

            YELLOW: begin
                if (timer_en)
                    timer <= timer - 1;
                else begin
                    state <= RED;
                    timer <= RED_TIME;
                end
                ped_shortened <= 1'b0; // Ensure flag reset outside green
            end

            default: begin
                state         <= RED;
                timer         <= RED_TIME;
                ped_shortened <= 1'b0;
            end
        endcase
    end
end

// Outputs combinational from current state and timer
always @(*) begin
    red    = (state == RED);
    yellow = (state == YELLOW);
    green  = (state == GREEN);
    clock  = timer;
end

endmodule