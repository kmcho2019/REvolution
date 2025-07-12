module traffic_light (
    input  wire       rst_n,
    input  wire       clk,
    input  wire       pass_request,
    output reg [7:0]  clock,
    output reg        red,
    output reg        yellow,
    output reg        green
);

// State encoding
localparam RED    = 2'd0;
localparam GREEN  = 2'd1;
localparam YELLOW = 2'd2;

// Timing parameters
localparam RED_TIME    = 8'd10;
localparam YELLOW_TIME = 8'd5;
localparam GREEN_TIME  = 8'd60;
localparam SHORT_GREEN = 8'd10;

// Synchronize pass_request to clk domain to avoid glitches
reg pass_request_sync_0, pass_request_sync_1;
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        pass_request_sync_0 <= 1'b0;
        pass_request_sync_1 <= 1'b0;
    end else begin
        pass_request_sync_0 <= pass_request;
        pass_request_sync_1 <= pass_request_sync_0;
    end
end
wire pass_req_sync = pass_request_sync_1;

// FSM registers
reg [1:0] state;
reg [7:0] timer;
reg shortened_flag;

// Combined update always block with clock enable
// Clock enable is high when timer > 0 or state changes to minimize toggling
wire timer_expired = (timer == 8'd0);

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state         <= RED;
        timer         <= RED_TIME;
        shortened_flag <= 1'b0;
    end else begin
        // State and timer update only when timer > 0 or when transitioning states
        // This avoids unnecessary toggling
        if (timer > 0) begin
            timer <= timer - 1;
        end else begin
            // Timer expired, move to next state and load corresponding timer
            case(state)
                RED: begin
                    state <= GREEN;
                    timer <= GREEN_TIME;
                    shortened_flag <= 1'b0; // reset shortened flag on entering green
                end
                GREEN: begin
                    state <= YELLOW;
                    timer <= YELLOW_TIME;
                    shortened_flag <= 1'b0;
                end
                YELLOW: begin
                    state <= RED;
                    timer <= RED_TIME;
                    shortened_flag <= 1'b0;
                end
                default: begin
                    state <= RED;
                    timer <= RED_TIME;
                    shortened_flag <= 1'b0;
                end
            endcase
        end

        // Handle pass request shortening logic only in GREEN state
        if ((state == GREEN) && pass_req_sync && (timer > SHORT_GREEN) && !shortened_flag) begin
            timer <= SHORT_GREEN;
            shortened_flag <= 1'b1;
        end
    end
end

// Output logic: combinational from state and timer
always @(*) begin
    red    = (state == RED);
    yellow = (state == YELLOW);
    green  = (state == GREEN);
    clock  = timer;
end

endmodule