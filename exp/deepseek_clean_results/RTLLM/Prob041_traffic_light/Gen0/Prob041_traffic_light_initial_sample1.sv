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
parameter idle  = 2'b00;
parameter s1_red = 2'b01;
parameter s2_yellow = 2'b10;
parameter s3_green = 2'b11;

reg [1:0] state;
reg [7:0] cnt;
reg p_red, p_yellow, p_green;

// State transition logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= idle;
    end else begin
        case (state)
            idle: state <= s1_red;
            
            s1_red: begin
                if (cnt == 8'd1) begin
                    state <= s3_green;
                end else begin
                    state <= s1_red;
                end
            end
            
            s2_yellow: begin
                if (cnt == 8'd1) begin
                    state <= s1_red;
                end else begin
                    state <= s2_yellow;
                end
            end
            
            s3_green: begin
                if (cnt == 8'd1) begin
                    state <= s2_yellow;
                end else begin
                    state <= s3_green;
                end
            end
            
            default: state <= idle;
        endcase
    end
end

// Counter logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt <= 8'd10;
    end else begin
        // Handle pedestrian request during green phase
        if (pass_request && (state == s3_green) begin
            if (cnt > 8'd10) begin
                cnt <= 8'd10;
            end
        end
        // State transition counter loading
        else if ((state == s1_red) && (cnt == 8'd1)) begin
            cnt <= 8'd60;  // Load green duration
        end
        else if ((state == s2_yellow) && (cnt == 8'd1)) begin
            cnt <= 8'd10;  // Load red duration
        end
        else if ((state == s3_green) && (cnt == 8'd1)) begin
            cnt <= 8'd5;   // Load yellow duration
        end
        // Normal countdown
        else if (cnt > 8'd0) begin
            cnt <= cnt - 8'd1;
        end
    end
end

// Next state output logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        p_red <= 1'b0;
        p_yellow <= 1'b0;
        p_green <= 1'b0;
    end else begin
        case (state)
            s1_red: begin
                p_red <= 1'b1;
                p_yellow <= 1'b0;
                p_green <= 1'b0;
            end
            s2_yellow: begin
                p_red <= 1'b0;
                p_yellow <= 1'b1;
                p_green <= 1'b0;
            end
            s3_green: begin
                p_red <= 1'b0;
                p_yellow <= 1'b0;
                p_green <= 1'b1;
            end
            default: begin
                p_red <= 1'b0;
                p_yellow <= 1'b0;
                p_green <= 1'b0;
            end
        endcase
    end
end

// Output assignments
assign red = p_red;
assign yellow = p_yellow;
assign green = p_green;
assign clock = cnt;

endmodule