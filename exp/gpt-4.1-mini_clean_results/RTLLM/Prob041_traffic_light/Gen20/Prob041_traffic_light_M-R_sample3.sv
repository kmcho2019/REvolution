module traffic_light (
    input  wire       rst_n,
    input  wire       clk,
    input  wire       pass_request,
    output reg  [6:0] clock,
    output reg        red,
    output reg        yellow,
    output reg        green
);

// State encoding
localparam [1:0]
    RED    = 2'b00,
    GREEN  = 2'b01,
    YELLOW = 2'b10;

// Timing constants
localparam [6:0]
    RED_TIME    = 7'd10,
    YELLOW_TIME = 7'd5,
    GREEN_TIME  = 7'd60,
    SHORT_GREEN = 7'd10;

// State and timer registers
reg [1:0] state, next_state;
reg [6:0] timer, next_timer;
// Pedestrian shortened flag register
reg ped_shortened, next_ped_shortened;

// State and timer sequential update
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state         <= RED;
        timer         <= RED_TIME;
        ped_shortened <= 1'b0;
    end else begin
        state         <= next_state;
        timer         <= next_timer;
        ped_shortened <= next_ped_shortened;
    end
end

// Combinational logic for next state, timer and ped_shortened
always @(*) begin
    // Defaults
    next_state         = state;
    next_timer         = timer;
    next_ped_shortened = ped_shortened;

    case (state)
        RED: begin
            if (timer == 7'd0) begin
                next_state = GREEN;
                next_timer = GREEN_TIME;
                next_ped_shortened = 1'b0;
            end else if (timer > 0) begin
                next_timer = timer - 1;
            end
        end

        GREEN: begin
            if (pass_request && (timer > SHORT_GREEN) && !ped_shortened) begin
                next_timer         = SHORT_GREEN;
                next_state         = GREEN;
                next_ped_shortened = 1'b1;
            end else if (timer == 7'd0) begin
                next_state = YELLOW;
                next_timer = YELLOW_TIME;
                next_ped_shortened = 1'b0;
            end else if (timer > 0) begin
                next_timer = timer - 1;
            end
        end

        YELLOW: begin
            if (timer == 7'd0) begin
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

// Registered outputs updated synchronously to avoid glitches
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        red    <= 1'b0;
        yellow <= 1'b0;
        green  <= 1'b0;
        clock  <= 7'd0;
    end else begin
        red    <= (state == RED);
        yellow <= (state == YELLOW);
        green  <= (state == GREEN);
        clock  <= timer;
    end
end

endmodule