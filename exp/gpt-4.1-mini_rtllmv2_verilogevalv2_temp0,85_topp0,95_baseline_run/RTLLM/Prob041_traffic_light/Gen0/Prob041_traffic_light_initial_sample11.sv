module traffic_light(
    input rst_n,
    input clk,
    input pass_request,
    output reg [7:0] clock,
    output reg red,
    output reg yellow,
    output reg green
);

// State encoding
localparam idle      = 2'd0;
localparam s1_red    = 2'd1; // red light
localparam s2_yellow = 2'd2; // yellow light
localparam s3_green  = 2'd3; // green light

reg [1:0] state;
reg [7:0] cnt;

reg p_red, p_yellow, p_green;

// State transition logic and next output logic
always @(*) begin
    // Default outputs to zero
    p_red = 0;
    p_yellow = 0;
    p_green = 0;

    case(state)
        idle: begin
            // All off
            p_red = 0;
            p_yellow = 0;
            p_green = 0;
        end
        s1_red: begin
            p_red = 1;
            p_yellow = 0;
            p_green = 0;
        end
        s2_yellow: begin
            p_red = 0;
            p_yellow = 1;
            p_green = 0;
        end
        s3_green: begin
            p_red = 0;
            p_yellow = 0;
            p_green = 1;
        end
        default: begin
            p_red = 0;
            p_yellow = 0;
            p_green = 0;
        end
    endcase
end

// State update and transitions based on counter
always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        state <= idle;
    end else begin
        case(state)
            idle: state <= s1_red;
            s1_red: if(cnt == 8'd0) state <= s3_green; else state <= s1_red;
            s2_yellow: if(cnt == 8'd0) state <= s1_red; else state <= s2_yellow;
            s3_green: if(cnt == 8'd0) state <= s2_yellow; else state <= s3_green;
            default: state <= idle;
        endcase
    end
end

// Counter logic and adjustments
always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        cnt <= 8'd10; // start red duration by default on reset
    end else begin
        // Detect state changes by previous light signals compared to current
        // When entering a new state, load the corresponding counter value
        if(state == idle) begin
            cnt <= 8'd10; // prepare for red on next cycle
        end else if(state == s1_red) begin
            // On entering red state (previous not red)
            if(!p_red) cnt <= 8'd10;
            else if(cnt > 0) cnt <= cnt - 1;
        end else if(state == s2_yellow) begin
            // On entering yellow state (previous not yellow)
            if(!p_yellow) cnt <= 8'd5;
            else if(cnt > 0) cnt <= cnt - 1;
        end else if(state == s3_green) begin
            // On entering green state (previous not green)
            if(!p_green) cnt <= 8'd60;
            else begin
                // If pedestrian request and remaining green time > 10, shorten to 10
                if(pass_request && (cnt > 8'd10))
                    cnt <= 8'd10;
                else if(cnt > 0)
                    cnt <= cnt - 1;
            end
        end else begin
            // Default decrement if no state matched
            if(cnt > 0) cnt <= cnt - 1;
        end
    end
end

// Output the current counter value
always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        clock <= 8'd10;
    end else begin
        clock <= cnt;
    end
end

// Update output lights from next state registers on clock
always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        red <= 0;
        yellow <= 0;
        green <= 0;
    end else begin
        red <= p_red;
        yellow <= p_yellow;
        green <= p_green;
    end
end

endmodule