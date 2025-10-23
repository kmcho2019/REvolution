module traffic_light(
    input rst_n,
    input clk,
    input pass_request,
    output [7:0] clock,
    output red,
    output yellow,
    output green
);

// State encoding
parameter idle      = 2'b00;
parameter s1_red    = 2'b01;
parameter s2_yellow = 2'b10;
parameter s3_green  = 2'b11;

reg [1:0] state, next_state;
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
    next_state = state;
    case (state)
        idle: next_state = s1_red;
        
        s1_red: begin
            if (cnt == 8'd1) next_state = s3_green;
        end
        
        s2_yellow: begin
            if (cnt == 8'd1) next_state = s1_red;
        end
        
        s3_green: begin
            if (cnt == 8'd1) next_state = s2_yellow;
        end
        
        default: next_state = idle;
    endcase
end

// Counter logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt <= 8'd10;  // Start with red light duration
    end else begin
        // Handle state transitions and counter reload
        case (state)
            s1_red: begin
                if (cnt == 8'd1) cnt <= 8'd60;  // Load green duration
                else cnt <= cnt - 8'd1;
            end
            
            s2_yellow: begin
                if (cnt == 8'd1) cnt <= 8'd10;  // Load red duration
                else cnt <= cnt - 8'd1;
            end
            
            s3_green: begin
                // Handle pedestrian request
                if (pass_request && cnt > 8'd10) begin
                    cnt <= 8'd10;
                end
                else if (cnt == 8'd1) begin
                    cnt <= 8'd5;   // Load yellow duration
                end
                else begin
                    cnt <= cnt - 8'd1;
                end
            end
            
            default: cnt <= 8'd10;
        endcase
    end
end

// Output logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        p_red <= 1'b0;
        p_yellow <= 1'b0;
        p_green <= 1'b0;
    end else begin
        p_red <= (state == s1_red);
        p_yellow <= (state == s2_yellow);
        p_green <= (state == s3_green);
    end
end

// Output assignments
assign red = p_red;
assign yellow = p_yellow;
assign green = p_green;
assign clock = cnt;

endmodule