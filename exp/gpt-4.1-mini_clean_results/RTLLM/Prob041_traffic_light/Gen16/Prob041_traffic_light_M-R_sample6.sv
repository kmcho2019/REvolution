module traffic_light (
    input  wire        rst_n,
    input  wire        clk,
    input  wire        pass_request,
    output wire [7:0]  clock,
    output wire        red,
    output wire        yellow,
    output wire        green
);

// State encoding (2 bits)
localparam IDLE   = 2'd0;
localparam RED    = 2'd1;
localparam YELLOW = 2'd2;
localparam GREEN  = 2'd3;

// Timing constants
localparam RED_TIME    = 8'd10;
localparam YELLOW_TIME = 8'd5;
localparam GREEN_TIME  = 8'd60;
localparam SHORT_GREEN = 8'd10;

reg [1:0] state, next_state;
reg [7:0] timer, next_timer;
reg       ped_shortened, next_ped_shortened;

// State register
always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
        state <= RED;
    else
        state <= next_state;
end

// Timer and pedestrian shorten flag registers
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        timer         <= RED_TIME;
        ped_shortened <= 1'b0;
    end else begin
        timer         <= next_timer;
        ped_shortened <= next_ped_shortened;
    end
end

// Next state logic
always @(*) begin
    case (state)
        RED: begin
            if (timer == 0)
                next_state = GREEN;
            else
                next_state = RED;
        end

        GREEN: begin
            if (timer == 0)
                next_state = YELLOW;
            else
                next_state = GREEN;
        end

        YELLOW: begin
            if (timer == 0)
                next_state = RED;
            else
                next_state = YELLOW;
        end

        default: next_state = RED;
    endcase
end

// Next timer and pedestrian shortened flag logic
always @(*) begin
    next_timer         = timer;
    next_ped_shortened = ped_shortened;

    if (timer != 0) begin
        // Decrement timer by default
        next_timer = timer - 1;
    end

    case (state)
        RED: begin
            if (timer == 0) begin
                next_timer = GREEN_TIME;
                next_ped_shortened = 1'b0; // Reset ped shorten on green start
            end
        end

        GREEN: begin
            if (pass_request && !ped_shortened && (timer > SHORT_GREEN)) begin
                // Shorten green timer
                next_timer = SHORT_GREEN;
                next_ped_shortened = 1'b1;
            end else if (timer == 0) begin
                next_timer = YELLOW_TIME;
                next_ped_shortened = 1'b0;
            end
        end

        YELLOW: begin
            if (timer == 0) begin
                next_timer = RED_TIME;
                next_ped_shortened = 1'b0;
            end
        end

        default: begin
            next_timer = RED_TIME;
            next_ped_shortened = 1'b0;
        end
    endcase
end

// Outputs assigned combinationally from state
assign red    = (state == RED);
assign yellow = (state == YELLOW);
assign green  = (state == GREEN);
assign clock  = timer;

endmodule