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
localparam idle      = 2'd0;
localparam s1_red    = 2'd1;
localparam s2_yellow = 2'd2;
localparam s3_green  = 2'd3;

// Fixed state durations in clock cycles
localparam IDLE_TIME    = 8'd0;
localparam RED_TIME     = 8'd10;
localparam YELLOW_TIME  = 8'd5;
localparam GREEN_TIME   = 8'd60;
localparam GREEN_SHORT  = 8'd10;

reg [1:0] state, next_state;
reg [7:0] timer;           // counts elapsed cycles in current state
reg [7:0] green_duration;  // current green duration (may be shortened)

reg pass_req_meta, pass_req_sync1;
wire pass_request_sync;

// Synchronize pass_request to clk domain (2-stage synchronizer)
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        pass_req_meta  <= 1'b0;
        pass_req_sync1 <= 1'b0;
    end else begin
        pass_req_meta  <= pass_request;
        pass_req_sync1 <= pass_req_meta;
    end
end
assign pass_request_sync = pass_req_sync1;

reg green_shortened; // flag indicating if green duration has been shortened in current green cycle

// State register and timer
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state          <= idle;
        timer          <= 8'd0;
        green_duration <= GREEN_TIME;
    end else begin
        state <= next_state;
        if (state == next_state) begin
            // Continue counting in same state
            timer <= timer + 8'd1;
        end else begin
            // State changed, reset timer
            timer <= 8'd0;
            // Reset green_duration to full green time on entering green state
            if (next_state == s3_green)
                green_duration <= GREEN_TIME;
        end
    end
end

// Next state logic based on timer reaching duration - 1
always @(*) begin
    next_state = state;
    case(state)
        idle: 
            next_state = s1_red; // immediately move to s1_red
        s1_red:
            if (timer == RED_TIME - 1)
                next_state = s3_green;
        s3_green:
            if (timer == green_duration - 1)
                next_state = s2_yellow;
        s2_yellow:
            if (timer == YELLOW_TIME - 1)
                next_state = s1_red;
        default:
            next_state = idle;
    endcase
end

// Green duration shortening logic and shortening flag management
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        green_shortened <= 1'b0;
        green_duration  <= GREEN_TIME;
    end else begin
        // Reset shortening flag when entering green state
        if (state != s3_green && next_state == s3_green) begin
            green_shortened <= 1'b0;
            green_duration  <= GREEN_TIME;
        end else if (state == s3_green) begin
            if (pass_request_sync && !green_shortened) begin
                // Calculate remaining green time = green_duration - timer - 1
                // timer counts from 0 up to green_duration - 1
                if ((green_duration - timer - 8'd1) > GREEN_SHORT) begin
                    // Shorten green_duration to elapsed time + GREEN_SHORT
                    green_duration <= timer + GREEN_SHORT;
                    green_shortened <= 1'b1;
                end
                // else do nothing if remaining green time <= GREEN_SHORT
            end
        end
        // No changes in other states
    end
end

// Outputs combinationally from state
assign red    = (state == s1_red);
assign yellow = (state == s2_yellow);
assign green  = (state == s3_green);

// Output timer value
assign clock = timer;

endmodule