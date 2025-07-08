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
parameter idle      = 2'b00,
          s1_red    = 2'b01,
          s2_yellow = 2'b10,
          s3_green  = 2'b11;

reg [7:0] cnt;
reg [1:0] state;
reg p_red, p_yellow, p_green;

// State transition logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= idle;
        p_red <= 0;
        p_yellow <= 0;
        p_green <= 0;
    end else begin
        case (state)
            idle: begin
                p_red <= 0;
                p_yellow <= 0;
                p_green <= 0;
                state <= s1_red; // move to s1_red immediately
            end
            s1_red: begin
                p_red <= 1;
                p_yellow <= 0;
                p_green <= 0;
                if (cnt == 8'd0)
                    state <= s3_green;
                else
                    state <= s1_red;
            end
            s2_yellow: begin
                p_red <= 0;
                p_yellow <= 1;
                p_green <= 0;
                if (cnt == 8'd0)
                    state <= s1_red;
                else
                    state <= s2_yellow;
            end
            s3_green: begin
                p_red <= 0;
                p_yellow <= 0;
                p_green <= 1;
                if (cnt == 8'd0)
                    state <= s2_yellow;
                else
                    state <= s3_green;
            end
            default: begin
                p_red <= 0;
                p_yellow <= 0;
                p_green <= 0;
                state <= idle;
            end
        endcase
    end
end

// Counter logic and pedestrian request handling
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt <= 8'd10;
    end else begin
        // If in green state and pass_request asserted and remaining cnt > 10, shorten to 10
        if (state == s3_green && pass_request && cnt > 8'd10) begin
            cnt <= 8'd10;
        end
        else if (cnt > 0) begin
            cnt <= cnt - 1'b1;
        end

        // Reset counters on state change
        // Detect rising edge of state signals by comparing current and previous p_red/yellow/green
        // When green turns off (p_green==1 and green==0), set counter to 60
        else if (state == s1_red && p_green == 1 && p_red == 0 && p_yellow == 0) begin
            // green just ended and now red starts
            cnt <= 8'd10;
        end
        else if (state == s2_yellow && p_green == 1 && p_yellow == 0) begin
            // green ended, yellow starts
            cnt <= 8'd5;
        end
        else if (state == s2_yellow && p_yellow == 1 && p_red == 0 && state != s2_yellow) begin
            // yellow ended, red starts
            cnt <= 8'd10;
        end
        else if (state == s2_yellow && p_yellow == 1 && cnt == 0) begin
            cnt <= 8'd10;
        end
        else begin
            // On state transition, set appropriate counter
            case (state)
                s1_red: begin
                    if (cnt == 8'd0)
                        cnt <= 8'd10;
                end
                s2_yellow: begin
                    if (cnt == 8'd0)
                        cnt <= 8'd5;
                end
                s3_green: begin
                    if (cnt == 8'd0)
                        cnt <= 8'd60;
                end
                idle: begin
                    cnt <= 8'd10;
                end
                default: cnt <= cnt;
            endcase
        end
    end
end

// Assign the output clock as the current count value
always @(posedge clk or negedge rst_n) begin
    if(!rst_n)
        clock <= 8'd10;
    else
        clock <= cnt;
end

// Output the light signals at clock edge
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
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