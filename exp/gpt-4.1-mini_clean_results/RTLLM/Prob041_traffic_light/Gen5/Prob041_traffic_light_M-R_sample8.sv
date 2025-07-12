module traffic_light (
    input  wire       rst_n,
    input  wire       clk,
    input  wire       pass_request,
    output wire [7:0] clock,
    output wire       red,
    output wire       yellow,
    output wire       green
);

// State encoding
localparam IDLE   = 2'd0;
localparam RED    = 2'd1;
localparam YELLOW = 2'd2;
localparam GREEN  = 2'd3;

// State durations (clock cycles)
localparam RED_TIME    = 8'd10;
localparam YELLOW_TIME = 8'd5;
localparam GREEN_TIME  = 8'd60;
localparam SHORT_GREEN = 8'd10;

reg [1:0]  state, next_state;
reg [7:0]  timer, next_timer;
reg        ped_shortened, ped_shortened_next;

// State update
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state          <= RED;
        timer          <= RED_TIME;
        ped_shortened  <= 1'b0;
    end else begin
        state         <= next_state;
        timer         <= next_timer;
        ped_shortened <= ped_shortened_next;
    end
end

// Next state and timer calculation
always @(*) begin
    // Default assignments
    next_state         = state;
    next_timer         = timer;
    ped_shortened_next = ped_shortened;

    case (state)
        RED: begin
            if (timer == 0) begin
                next_state = GREEN;
                next_timer = GREEN_TIME;
                ped_shortened_next = 1'b0; // Reset shortening flag on green entry
            end else begin
                next_timer = timer - 1;
            end
        end

        GREEN: begin
            // Apply pedestrian shortening if needed
            if (pass_request && !ped_shortened && (timer > SHORT_GREEN)) begin
                next_timer = SHORT_GREEN;
                ped_shortened_next = 1'b1;
            end else if (timer == 0) begin
                next_state = YELLOW;
                next_timer = YELLOW_TIME;
            end else begin
                next_timer = timer - 1;
            end
        end

        YELLOW: begin
            if (timer == 0) begin
                next_state = RED;
                next_timer = RED_TIME;
            end else begin
                next_timer = timer - 1;
            end
        end

        default: begin
            next_state = RED;
            next_timer = RED_TIME;
            ped_shortened_next = 1'b0;
        end
    endcase
end

// Outputs driven by continuous assignments
assign red    = (state == RED);
assign yellow = (state == YELLOW);
assign green  = (state == GREEN);
assign clock  = timer;

endmodule