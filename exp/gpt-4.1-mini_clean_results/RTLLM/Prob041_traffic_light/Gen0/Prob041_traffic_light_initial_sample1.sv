module traffic_light(
    input rst_n,
    input clk,
    input pass_request,
    output reg [7:0] clock,
    output reg red,
    output reg yellow,
    output reg green
);

// States encoding
localparam idle    = 2'd0;
localparam s1_red  = 2'd1;
localparam s2_yellow = 2'd2;
localparam s3_green  = 2'd3;

reg [7:0] cnt;
reg [1:0] state;
reg p_red, p_yellow, p_green;

// State transition logic and outputs setting
always @(*) begin
    // Default next outputs zeroed
    p_red = 1'b0;
    p_yellow = 1'b0;
    p_green = 1'b0;

    case(state)
        idle: begin
            // Idle state: all off, immediately transition to s1_red in sequential block
            p_red = 1'b0;
            p_yellow = 1'b0;
            p_green = 1'b0;
        end
        s1_red: begin
            p_red = 1'b1;
            p_yellow = 1'b0;
            p_green = 1'b0;
        end
        s2_yellow: begin
            p_red = 1'b0;
            p_yellow = 1'b1;
            p_green = 1'b0;
        end
        s3_green: begin
            p_red = 1'b0;
            p_yellow = 1'b0;
            p_green = 1'b1;
        end
        default: begin
            p_red = 1'b0;
            p_yellow = 1'b0;
            p_green = 1'b0;
        end
    endcase
end

// Sequential logic: state transitions and counter
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= idle;
        cnt <= 8'd10; // Initialize counter to red time on reset
    end else begin
        case(state)
            idle: begin
                // Transition immediately to s1_red, initialize counter for red
                state <= s1_red;
                cnt <= 8'd10;
            end
            s1_red: begin
                if (cnt == 8'd1) begin
                    state <= s3_green;
                    cnt <= 8'd60; // green duration
                end else begin
                    cnt <= cnt - 1;
                end
            end
            s3_green: begin
                // Handle pedestrian request to shorten green if remaining > 10
                if (pass_request && (cnt > 8'd10)) begin
                    cnt <= 8'd10;
                end else if (cnt == 8'd1) begin
                    state <= s2_yellow;
                    cnt <= 8'd5;
                end else begin
                    cnt <= cnt - 1;
                end
            end
            s2_yellow: begin
                if (cnt == 8'd1) begin
                    state <= s1_red;
                    cnt <= 8'd10;
                end else begin
                    cnt <= cnt - 1;
                end
            end
            default: begin
                state <= idle;
                cnt <= 8'd10;
            end
        endcase
    end
end

// Assign internal counter to output clock
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        clock <= 8'd10;
    end else begin
        clock <= cnt;
    end
end

// Update output signals with p_ values each clock or reset
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        red <= 1'b0;
        yellow <= 1'b0;
        green <= 1'b0;
    end else begin
        red <= p_red;
        yellow <= p_yellow;
        green <= p_green;
    end
end

endmodule