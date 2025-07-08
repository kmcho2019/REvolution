module traffic_light(
    input wire rst_n,
    input wire clk,
    input wire pass_request,
    output reg [7:0] clock,
    output reg red,
    output reg yellow,
    output reg green
);

// State encoding
localparam idle     = 2'd0;
localparam s1_red   = 2'd1;
localparam s2_yellow= 2'd2;
localparam s3_green = 2'd3;

// Registers
reg [7:0] cnt;
reg [1:0] state;
reg p_red, p_yellow, p_green;

// State transition and output logic
always @(*) begin
    // Defaults: no lights on
    p_red = 1'b0;
    p_yellow = 1'b0;
    p_green = 1'b0;
    case(state)
        idle: begin
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

// State transition
always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        state <= idle;
    end else begin
        case(state)
            idle: begin
                // Immediately go to s1_red
                state <= s1_red;
            end
            s1_red: begin
                // Wait until count 0, then green
                if(cnt == 0)
                    state <= s3_green;
                else
                    state <= s1_red;
            end
            s2_yellow: begin
                // Wait until count 0, then red
                if(cnt == 0)
                    state <= s1_red;
                else
                    state <= s2_yellow;
            end
            s3_green: begin
                // Wait until count 0, then yellow
                if(cnt == 0)
                    state <= s2_yellow;
                else
                    state <= s3_green;
            end
            default: state <= idle;
        endcase
    end
end

// Counter logic and pass_request handling
always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        cnt <= 8'd10; // Start with red time as per question
    end else begin
        // When entering a new state, load proper time
        // Check transitions by comparing current outputs with previous outputs
        if(state == idle) begin
            cnt <= 8'd10; // idle just set counter to red time (10)
        end else if(state == s1_red && (p_red == 1'b0 || cnt == 0)) begin
            // New s1_red state or counter zero reload
            // When entering red: 10 clocks
            // "If the red signal is inactive and the previous red signal was active" handled below, so here set on entering s1_red
            if(p_red == 1'b0 || cnt == 0) cnt <= 8'd10;
        end else if(state == s2_yellow && (p_yellow == 1'b0 || cnt == 0)) begin
            // Yellow time 5 clocks
            if(p_yellow == 1'b0 || cnt == 0) cnt <= 8'd5;
        end else if(state == s3_green) begin
            // Green time 60 clocks normally
            // Handle pass_request: if pass_request and cnt > 10 then cnt=10
            if(pass_request && p_green && cnt > 8'd10)
                cnt <= 8'd10;
            else if(p_green == 1'b0 || cnt == 0) begin
                // Entering green
                cnt <= 8'd60;
            end else begin
                cnt <= cnt - 1;
            end
        end else begin
            // Normal decrement if none of above conditions
            if(cnt > 0)
                cnt <= cnt - 1;
        end
    end
end

// Output update registers
always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        red <= 1'b0;
        yellow <= 1'b0;
        green <= 1'b0;
    end else begin
        red <= p_red;
        yellow <= p_yellow;
        green <= p_green;
    end
end

// Output clock counter
always @(*) begin
    clock = cnt;
end

endmodule