module traffic_light (
    input  wire       rst_n,
    input  wire       clk,
    input  wire       pass_request,
    output wire [7:0] clock,
    output wire       red,
    output wire       yellow,
    output wire       green
);

// State encoding (2 bits)
localparam IDLE      = 2'd0;
localparam RED       = 2'd1;
localparam YELLOW    = 2'd2;
localparam GREEN     = 2'd3;

// Timing parameters
localparam RED_TIME    = 8'd10;
localparam YELLOW_TIME = 8'd5;
localparam GREEN_TIME  = 8'd60;
localparam SHORT_GREEN = 8'd10;

// State and timer registers
reg [1:0] state, next_state;
reg [7:0] timer, next_timer;
reg       ped_shortened, next_ped_shortened;

// State register update
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

// Next-state and pedestrian shortened flag logic
always @(*) begin
    // Defaults: hold current values
    next_state = state;
    next_ped_shortened = ped_shortened;

    case(state)
        RED: begin
            if (timer == 0) begin
                next_state = GREEN;
                next_ped_shortened = 1'b0; // reset ped flag on green start
            end
        end
        GREEN: begin
            if (timer == 0) begin
                next_state = YELLOW;
                next_ped_shortened = 1'b0;
            end else if (pass_request && !ped_shortened && (timer > SHORT_GREEN)) begin
                // Pedestrian request shortens green phase once
                next_ped_shortened = 1'b1;
            end
        end
        YELLOW: begin
            if (timer == 0) begin
                next_state = RED;
                next_ped_shortened = 1'b0;
            end
        end
        default: begin
            next_state = RED;
            next_ped_shortened = 1'b0;
        end
    endcase
end

// Timer countdown and update logic
always @(*) begin
    case(state)
        RED: begin
            if (timer == 0) next_timer = RED_TIME;
            else            next_timer = timer - 1;
        end
        GREEN: begin
            if (timer == 0) begin
                next_timer = GREEN_TIME; // reload on next cycle in new state
            end else if (pass_request && !ped_shortened && (timer > SHORT_GREEN)) begin
                next_timer = SHORT_GREEN;
            end else begin
                next_timer = timer - 1;
            end
        end
        YELLOW: begin
            if (timer == 0) next_timer = YELLOW_TIME;
            else            next_timer = timer - 1;
        end
        default: begin
            next_timer = 8'd10;
        end
    endcase
end

// Outputs derived combinationally
assign red    = (state == RED);
assign yellow = (state == YELLOW);
assign green  = (state == GREEN);
assign clock  = timer;

endmodule