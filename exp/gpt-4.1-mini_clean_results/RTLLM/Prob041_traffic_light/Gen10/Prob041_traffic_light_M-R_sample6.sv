module traffic_light (
    input  wire       rst_n,
    input  wire       clk,
    input  wire       pass_request,
    output wire [7:0] clock,
    output wire       red,
    output wire       yellow,
    output wire       green
);

// State encoding with localparams
localparam IDLE   = 2'b00;
localparam RED    = 2'b01;
localparam YELLOW = 2'b10;
localparam GREEN  = 2'b11;

// Timing constants
localparam RED_TIME    = 8'd10;
localparam YELLOW_TIME = 8'd5;
localparam GREEN_TIME  = 8'd60;
localparam SHORT_GREEN = 8'd10;

// State register
reg [1:0] state, next_state;
// Timer register
reg [7:0] timer, next_timer;
// Pedestrian shortening flag for green phase
reg ped_shortened, next_ped_shortened;

// State register update
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state          <= RED;
        timer          <= RED_TIME;
        ped_shortened  <= 1'b0;
    end else begin
        state          <= next_state;
        timer          <= next_timer;
        ped_shortened  <= next_ped_shortened;
    end
end

// Combinational block for next state and timer calculation
always @(*) begin
    // Default next values: hold current state and decrement timer if nonzero
    next_state = state;
    if (timer != 0)
        next_timer = timer - 1;
    else
        next_timer = 0;

    // Default: no pedestrian shortening flag set or cleared
    next_ped_shortened = ped_shortened;

    case(state)
        RED: begin
            if (timer == 0) begin
                next_state = GREEN;
                next_timer = GREEN_TIME;
                next_ped_shortened = 1'b0; // Reset shortening at green start
            end
        end

        GREEN: begin
            if (pass_request && !ped_shortened && (timer > SHORT_GREEN)) begin
                // Shorten green timer to SHORT_GREEN
                next_timer = SHORT_GREEN;
                next_ped_shortened = 1'b1;
                next_state = GREEN;
            end else if (timer == 0) begin
                next_state = YELLOW;
                next_timer = YELLOW_TIME;
                next_ped_shortened = 1'b0; // Clear shortening after green ends
            end
        end

        YELLOW: begin
            if (timer == 0) begin
                next_state = RED;
                next_timer = RED_TIME;
            end
        end

        default: begin
            next_state = RED;
            next_timer = RED_TIME;
            next_ped_shortened = 1'b0;
        end
    endcase
end

// Output assignments using one-hot style logic for clarity and direct combinational logic
assign red    = (state == RED);
assign yellow = (state == YELLOW);
assign green  = (state == GREEN);
assign clock  = timer;

endmodule