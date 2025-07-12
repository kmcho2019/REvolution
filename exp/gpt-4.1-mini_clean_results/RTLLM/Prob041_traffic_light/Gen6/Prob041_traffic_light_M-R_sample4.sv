module traffic_light (
    input  wire       rst_n,
    input  wire       clk,
    input  wire       pass_request,
    output reg  [7:0] clock,
    output reg        red,
    output reg        yellow,
    output reg        green
);

// State encoding
typedef enum logic [1:0] {
    IDLE   = 2'd0,
    RED    = 2'd1,
    YELLOW = 2'd2,
    GREEN  = 2'd3
} state_t;

localparam [7:0] RED_TIME    = 8'd10;
localparam [7:0] YELLOW_TIME = 8'd5;
localparam [7:0] GREEN_TIME  = 8'd60;
localparam [7:0] SHORT_GREEN = 8'd10;

state_t state, next_state;

reg [7:0] timer, next_timer;
reg       ped_shortened, next_ped_shortened;

// Next state logic (combinational)
always @(*) begin
    case(state)
        IDLE:     next_state = RED;
        RED:      next_state = (timer == 0) ? GREEN : RED;
        GREEN:    next_state = (timer == 0) ? YELLOW : GREEN;
        YELLOW:   next_state = (timer == 0) ? RED : YELLOW;
        default:  next_state = RED;
    endcase
end

// Next timer logic and pedestrian shortening (combinational)
always @(*) begin
    next_timer = timer;
    next_ped_shortened = ped_shortened;

    case(state)
        IDLE: begin
            next_timer = RED_TIME;
            next_ped_shortened = 1'b0;
        end

        RED: begin
            if (timer == 0)
                next_timer = GREEN_TIME;
            else
                next_timer = timer - 1;
            next_ped_shortened = 1'b0; // reset shortening on RED
        end

        GREEN: begin
            if (pass_request && !ped_shortened && (timer > SHORT_GREEN)) begin
                next_timer = SHORT_GREEN;
                next_ped_shortened = 1'b1;
            end else if (timer == 0) begin
                next_timer = YELLOW_TIME;
                next_ped_shortened = ped_shortened;
            end else begin
                next_timer = timer - 1;
                next_ped_shortened = ped_shortened;
            end
        end

        YELLOW: begin
            if (timer == 0)
                next_timer = RED_TIME;
            else
                next_timer = timer - 1;
            next_ped_shortened = 1'b0;
        end

        default: begin
            next_timer = RED_TIME;
            next_ped_shortened = 1'b0;
        end
    endcase
end

// Sequential logic for state, timer, outputs, and ped_shortened flag
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state         <= RED;
        timer         <= RED_TIME;
        ped_shortened <= 1'b0;
        red           <= 1'b1;
        yellow        <= 1'b0;
        green         <= 1'b0;
        clock         <= RED_TIME;
    end else begin
        state         <= next_state;
        timer         <= next_timer;
        ped_shortened <= next_ped_shortened;
        clock         <= next_timer;

        // Output signals updated based on current state
        case (next_state)
            RED: begin
                red    <= 1'b1;
                yellow <= 1'b0;
                green  <= 1'b0;
            end
            GREEN: begin
                red    <= 1'b0;
                yellow <= 1'b0;
                green  <= 1'b1;
            end
            YELLOW: begin
                red    <= 1'b0;
                yellow <= 1'b1;
                green  <= 1'b0;
            end
            default: begin
                red    <= 1'b0;
                yellow <= 1'b0;
                green  <= 1'b0;
            end
        endcase
    end
end

endmodule