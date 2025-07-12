module traffic_light (
    input  wire       rst_n,
    input  wire       clk,
    input  wire       pass_request,
    output reg  [5:0] clock,   // Reduced to 6 bits to cover up to 60
    output reg        red,
    output reg        yellow,
    output reg        green
);

// State encoding - 2 bits sufficient for 3 states
localparam [1:0]
    S_RED    = 2'd0,
    S_GREEN  = 2'd1,
    S_YELLOW = 2'd2;

localparam [5:0] RED_TIME    = 6'd10;
localparam [5:0] YELLOW_TIME = 6'd5;
localparam [5:0] GREEN_TIME  = 6'd60;
localparam [5:0] SHORT_GREEN = 6'd10;

reg [1:0] state, next_state;
reg [5:0] timer, next_timer;

// Synchronize pass_request to avoid glitches
reg pass_request_sync, pass_request_sync_d;
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        pass_request_sync   <= 1'b0;
        pass_request_sync_d <= 1'b0;
    end else begin
        pass_request_sync   <= pass_request;
        pass_request_sync_d <= pass_request_sync;
    end
end
wire pass_request_rising = pass_request_sync & ~pass_request_sync_d;

// State register update
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= S_RED;
    end else begin
        state <= next_state;
    end
end

// Timer register update
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        timer <= RED_TIME;
    end else begin
        timer <= next_timer;
    end
end

// Next state and timer logic (combinational)
always @(*) begin
    next_state = state;
    next_timer = timer;

    case(state)
        S_RED: begin
            if (timer == 0) begin
                next_state = S_GREEN;
                next_timer = GREEN_TIME;
            end else begin
                next_timer = timer - 1;
            end
        end

        S_GREEN: begin
            if (timer == 0) begin
                next_state = S_YELLOW;
                next_timer = YELLOW_TIME;
            end else begin
                // On pedestrian button press rising edge and if timer > SHORT_GREEN, shorten green time
                if (pass_request_rising && (timer > SHORT_GREEN)) begin
                    next_timer = SHORT_GREEN;
                end else if (timer > 0) begin
                    next_timer = timer - 1;
                end
            end
        end

        S_YELLOW: begin
            if (timer == 0) begin
                next_state = S_RED;
                next_timer = RED_TIME;
            end else begin
                next_timer = timer - 1;
            end
        end

        default: begin
            next_state = S_RED;
            next_timer = RED_TIME;
        end
    endcase
end

// Outputs registered to avoid glitches
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        red    <= 1'b0;
        yellow <= 1'b0;
        green  <= 1'b0;
        clock  <= 6'd0;
    end else begin
        red    <= (state == S_RED);
        yellow <= (state == S_YELLOW);
        green  <= (state == S_GREEN);
        clock  <= timer;
    end
end

endmodule