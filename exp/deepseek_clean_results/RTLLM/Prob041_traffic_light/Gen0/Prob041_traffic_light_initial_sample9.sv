module traffic_light(
    input rst_n,
    input clk,
    input pass_request,
    output reg [7:0] clock,
    output reg red,
    output reg yellow,
    output reg green
);

// State definitions
parameter idle = 2'b00;
parameter s1_red = 2'b01;
parameter s2_yellow = 2'b10;
parameter s3_green = 2'b11;

reg [1:0] state;
reg [1:0] next_state;
reg [7:0] cnt;
reg p_red, p_yellow, p_green;

// State transition logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= idle;
    end else begin
        state <= next_state;
    end
end

always @(*) begin
    case (state)
        idle: next_state = s1_red;
        s1_red: next_state = (cnt == 8'd1) ? s3_green : s1_red;
        s2_yellow: next_state = (cnt == 8'd1) ? s1_red : s2_yellow;
        s3_green: next_state = (cnt == 8'd1) ? s2_yellow : s3_green;
        default: next_state = idle;
    endcase
end

// Counter logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt <= 8'd10;  // Start with red light duration
        p_red <= 1'b0;
        p_yellow <= 1'b0;
        p_green <= 1'b0;
    end else begin
        // Handle pedestrian request during green light
        if (pass_request && green && (cnt > 8'd10)) begin
            cnt <= 8'd10;
        end
        // State transition counter updates
        else if (state == s1_red && next_state == s3_green) begin
            cnt <= 8'd60;  // Green light duration
        end
        else if (state == s3_green && next_state == s2_yellow) begin
            cnt <= 8'd5;    // Yellow light duration
        end
        else if (state == s2_yellow && next_state == s1_red) begin
            cnt <= 8'd10;   // Red light duration
        end
        else if (cnt > 8'd0) begin
            cnt <= cnt - 8'd1;
        end
        
        // Update next output values
        p_red <= (state == s1_red);
        p_yellow <= (state == s2_yellow);
        p_green <= (state == s3_green);
    end
end

// Output assignment
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        red <= 1'b0;
        yellow <= 1'b0;
        green <= 1'b0;
        clock <= 8'd0;
    end else begin
        red <= p_red;
        yellow <= p_yellow;
        green <= p_green;
        clock <= cnt;
    end
end

endmodule