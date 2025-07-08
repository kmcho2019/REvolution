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
localparam idle      = 2'd0;
localparam s1_red    = 2'd1;
localparam s2_yellow = 2'd2;
localparam s3_green  = 2'd3;

reg [7:0] cnt;
reg [1:0] state;
reg p_red, p_yellow, p_green;

// State transition and output signal next values logic
always @(*) begin
    // Default next values
    p_red    = 1'b0;
    p_yellow = 1'b0;
    p_green  = 1'b0;
    
    case (state)
        idle: begin
            // All signals off, next state immediately s1_red
            p_red    = 1'b0;
            p_yellow = 1'b0;
            p_green  = 1'b0;
        end
        s1_red: begin
            p_red = 1'b1;
        end
        s2_yellow: begin
            p_yellow = 1'b1;
        end
        s3_green: begin
            p_green = 1'b1;
        end
        default: begin
            p_red    = 1'b0;
            p_yellow = 1'b0;
            p_green  = 1'b0;
        end
    endcase
end

// State register update and state transitions based on cnt
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= idle;
    end else begin
        case (state)
            idle: state <= s1_red;  // Immediate transition from idle to s1_red
            s1_red: begin
                if (cnt == 8'd0) 
                    state <= s3_green;
                else
                    state <= s1_red;
            end
            s2_yellow: begin
                if (cnt == 8'd0)
                    state <= s1_red;
                else
                    state <= s2_yellow;
            end
            s3_green: begin
                if (cnt == 8'd0)
                    state <= s2_yellow;
                else
                    state <= s3_green;
            end
            default: state <= idle;
        endcase
    end
end

// Counter logic with special handling of pass_request
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt <= 8'd10; // Reset counter to red time by default
    end else begin
        if (state == s3_green) begin
            // In green state, handle pedestrian button to shorten green time
            if (pass_request) begin
                if (cnt > 8'd10)
                    cnt <= 8'd10;
                else
                    cnt <= (cnt == 8'd0) ? 8'd0 : cnt - 1;
            end else begin
                cnt <= (cnt == 8'd0) ? 8'd0 : cnt - 1;
            end
        end else if (state == s2_yellow) begin
            // Yellow light duration 5 clocks
            if (cnt == 8'd0) begin
                cnt <= 8'd5; // Reload after transition
            end else begin
                cnt <= cnt - 1;
            end
        end else if (state == s1_red) begin
            // Red light duration 10 clocks
            if (cnt == 8'd0) begin
                cnt <= 8'd10; // Reload after transition
            end else begin
                cnt <= cnt - 1;
            end
        end else if (state == idle) begin
            cnt <= 8'd10; // In idle, set default red time
        end else begin
            cnt <= cnt - 1; // Default decrement
        end
    end
end

// Initial counter loading on state changes:
// We detect state changes by previous output signals and current output signals
// and reload counter accordingly
reg p_red_d, p_yellow_d, p_green_d;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        p_red_d    <= 1'b0;
        p_yellow_d <= 1'b0;
        p_green_d  <= 1'b0;
    end else begin
        p_red_d    <= p_red;
        p_yellow_d <= p_yellow;
        p_green_d  <= p_green;
    end
end

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt <= 8'd10;
    end else begin
        // When green becomes active from inactive, load 60 unless shortened by pass_request
        if (p_green && !p_green_d) begin
            // On green start, load 60 unless pass_request active, then load 10
            if (pass_request)
                cnt <= 8'd10;
            else
                cnt <= 8'd60;
        end else if (p_yellow && !p_yellow_d) begin
            // On yellow start, load 5
            cnt <= 8'd5;
        end else if (p_red && !p_red_d) begin
            // On red start, load 10
            cnt <= 8'd10;
        end
        // Otherwise, counting down handled in the other always block
    end
end

// Update the outputs red, yellow, green synchronously to p_red, p_yellow, p_green
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        red    <= 1'b0;
        yellow <= 1'b0;
        green  <= 1'b0;
    end else begin
        red    <= p_red;
        yellow <= p_yellow;
        green  <= p_green;
    end
end

// Assign the internal counter to the output clock
always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
        clock <= 8'd10;
    else
        clock <= cnt;
end

endmodule