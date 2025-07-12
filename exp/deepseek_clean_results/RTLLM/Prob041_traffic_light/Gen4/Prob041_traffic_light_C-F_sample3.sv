module traffic_light(
    input rst_n,
    input clk,
    input pass_request,
    output [5:0] clock,
    output reg red,
    output reg yellow,
    output reg green
);

// State encoding
parameter idle      = 2'b00;
parameter s1_red    = 2'b01;
parameter s2_yellow = 2'b10;
parameter s3_green  = 2'b11;

reg [1:0] state;
reg [5:0] cnt;

// Combined state and counter logic with power optimization
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= idle;
        cnt <= 6'd10;  // Start with red light duration
        red <= 1'b0;
        yellow <= 1'b0;
        green <= 1'b0;
    end else begin
        // Default outputs (will be overridden in state cases)
        red <= 1'b0;
        yellow <= 1'b0;
        green <= 1'b0;
        
        case (state)
            idle: begin
                state <= s1_red;
                cnt <= 6'd10;
            end
            
            s1_red: begin
                red <= 1'b1;
                if (cnt == 6'd1) begin
                    state <= s3_green;
                    cnt <= 6'd60;
                end else if (cnt != 6'd0) begin  // Conditional decrement
                    cnt <= cnt - 6'd1;
                end
            end
            
            s2_yellow: begin
                yellow <= 1'b1;
                if (cnt == 6'd1) begin
                    state <= s1_red;
                    cnt <= 6'd10;
                end else if (cnt != 6'd0) begin
                    cnt <= cnt - 6'd1;
                end
            end
            
            s3_green: begin
                green <= 1'b1;
                // Handle pedestrian request
                if (pass_request && cnt > 6'd10) begin
                    cnt <= 6'd10;
                end
                else if (cnt == 6'd1) begin
                    state <= s2_yellow;
                    cnt <= 6'd5;
                end else if (cnt != 6'd0) begin
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

// Alternative registered outputs (uncomment if timing needs improvement)
/*
reg p_red, p_yellow, p_green;
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        p_red <= 1'b0;
        p_yellow <= 1'b0;
        p_green <= 1'b0;
    end else begin
        p_red <= red;
        p_yellow <= yellow;
        p_green <= green;
    end
end
assign red = p_red;
assign yellow = p_yellow;
assign green = p_green;
*/

assign clock = cnt;

endmodule