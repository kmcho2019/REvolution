module traffic_light (
    input  wire       rst_n,
    input  wire       clk,
    input  wire       pass_request,
    output reg [6:0]  clock,   // 7-bit timer output
    output reg        red,
    output reg        yellow,
    output reg        green
);

// State encoding
localparam IDLE      = 2'd0;
localparam RED       = 2'd1;
localparam YELLOW    = 2'd2;
localparam GREEN     = 2'd3;

// Timing parameters (cycles)
localparam RED_TIME    = 7'd10;
localparam YELLOW_TIME = 7'd5;
localparam GREEN_TIME  = 7'd60;
localparam SHORT_GREEN = 7'd10;

reg [1:0]  state, next_state;
reg [6:0]  timer, next_timer;
reg        ped_shortened, next_ped_shortened;

// Timer enable: only update timer register when needed to reduce toggling
wire timer_en = (timer != 0) || (state != next_state) || (timer != next_timer);

// Next-state combinational logic
always @(*) begin
    next_state = state;
    next_timer = timer;
    next_ped_shortened = ped_shortened;

    case (state)
        IDLE: begin
            next_state = RED;
            next_timer = RED_TIME;
            next_ped_shortened = 1'b0;
        end

        RED: begin
            if (timer == 0) begin
                next_state = GREEN;
                next_timer = GREEN_TIME;
                next_ped_shortened = 1'b0; // Reset ped_shortened on entering GREEN
            end else begin
                if (timer > 0)
                    next_timer = timer - 1;
            end
        end

        GREEN: begin
            // Pedestrian request shortens green time if not already shortened and timer > SHORT_GREEN
            if (pass_request && !ped_shortened && (timer > SHORT_GREEN)) begin
                next_timer = SHORT_GREEN;
                next_ped_shortened = 1'b1;
            end else if (timer == 0) begin
                next_state = YELLOW;
                next_timer = YELLOW_TIME;
                next_ped_shortened = 1'b0;
            end else if (timer > 0) begin
                next_timer = timer - 1;
            end
        end

        YELLOW: begin
            if (timer == 0) begin
                next_state = RED;
                next_timer = RED_TIME;
                next_ped_shortened = 1'b0;
            end else if (timer > 0) begin
                next_timer = timer - 1;
            end
        end

        default: begin
            next_state = RED;
            next_timer = RED_TIME;
            next_ped_shortened = 1'b0;
        end
    endcase
end

// Sequential logic block for state, timer, ped_shortened, and registered outputs
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state         <= RED;
        timer         <= RED_TIME;
        ped_shortened <= 1'b0;

        // Initialize outputs synchronously to avoid glitches
        red    <= 1'b1;
        yellow <= 1'b0;
        green  <= 1'b0;
        clock  <= RED_TIME;
    end else begin
        state         <= next_state;
        ped_shortened <= next_ped_shortened;

        // Update timer only if enabled to reduce toggling
        if (timer_en)
            timer <= next_timer;

        // Register outputs to reduce glitches and improve timing
        red    <= (next_state == RED);
        yellow <= (next_state == YELLOW);
        green  <= (next_state == GREEN);
        clock  <= next_timer;
    end
end

endmodule