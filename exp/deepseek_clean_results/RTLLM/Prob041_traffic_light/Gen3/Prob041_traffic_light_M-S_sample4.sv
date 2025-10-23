module traffic_light(
    input rst_n,
    input clk,
    input pass_request,
    output [5:0] clock,
    output red,
    output yellow,
    output green
);

// State encoding
parameter idle      = 2'b00;
parameter s1_red    = 2'b01;
parameter s2_yellow = 2'b10;
parameter s3_green  = 2'b11;

reg [1:0] state;
reg [5:0] cnt;

// Combined state and counter logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= idle;
        cnt <= 6'd10;  // Start with red light duration
    end else begin
        case (state)
            idle: begin
                state <= s1_red;
                cnt <= 6'd10;
            end
            
            s1_red: begin
                if (cnt == 6'd1) begin
                    state <= s3_green;
                    cnt <= 6'd60;
                end else begin
                    cnt <= cnt - 6'd1;
                end
            end
            
            s2_yellow: begin
                if (cnt == 6'd1) begin
                    state <= s1_red;
                    cnt <= 6'd10;
                end else begin
                    cnt <= cnt - 6'd1;
                end
            end
            
            s3_green: begin
                // Handle pedestrian request
                if (pass_request && cnt > 6'd10) begin
                    cnt <= 6'd10;
                end
                else if (cnt == 6'd1) begin
                    state <= s2_yellow;
                    cnt <= 6'd5;
                end else begin
                    cnt <= cnt - 6'd1;
                end
            end
            
            default: begin
                state <= s1_red;
                cnt <= 6'd10;
            end
        endcase
    end
end

// Direct combinatorial outputs
assign red = (state == s1_red);
assign yellow = (state == s2_yellow);
assign green = (state == s3_green);
assign clock = cnt;

endmodule