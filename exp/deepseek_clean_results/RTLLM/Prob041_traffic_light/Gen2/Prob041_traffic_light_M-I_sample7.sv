module traffic_light(
    input rst_n,
    input clk,
    input pass_request,
    output [5:0] clock,  // Reduced to 6 bits
    output reg red,
    output reg yellow,
    output reg green
);

// One-hot state encoding
parameter IDLE     = 3'b000;
parameter S1_RED   = 3'b001;
parameter S2_YELLOW = 3'b010;
parameter S3_GREEN = 3'b100;

// Timing parameters
parameter RED_TIME    = 6'd10;
parameter YELLOW_TIME = 6'd5;
parameter GREEN_TIME  = 6'd60;
parameter REQ_TIME    = 6'd10;

reg [2:0] state;
reg [5:0] cnt;  // 6-bit counter

// State transition logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= IDLE;
    end else begin
        case (state)
            IDLE: state <= S1_RED;
            
            S1_RED: begin
                if (cnt == 6'd1)
                    state <= S3_GREEN;
            end
            
            S2_YELLOW: begin
                if (cnt == 6'd1)
                    state <= S1_RED;
            end
            
            S3_GREEN: begin
                if (cnt == 6'd1)
                    state <= S2_YELLOW;
            end
            
            default: state <= IDLE;
        endcase
    end
end

// Optimized counter logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt <= RED_TIME;
    end else begin
        case (state)
            S1_RED: begin
                if (cnt == 6'd1)
                    cnt <= GREEN_TIME;
                else
                    cnt <= cnt - 1'b1;
            end
            
            S2_YELLOW: begin
                if (cnt == 6'd1)
                    cnt <= RED_TIME;
                else
                    cnt <= cnt - 1'b1;
            end
            
            S3_GREEN: begin
                if (pass_request && (cnt > REQ_TIME))
                    cnt <= REQ_TIME;
                else if (cnt == 6'd1)
                    cnt <= YELLOW_TIME;
                else
                    cnt <= cnt - 1'b1;
            end
            
            default: cnt <= RED_TIME;
        endcase
    end
end

// Direct output assignment with hold conditions
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        red <= 1'b0;
        yellow <= 1'b0;
        green <= 1'b0;
    end else begin
        case (state)
            S1_RED: begin
                red <= 1'b1;
                if (yellow || green) begin
                    yellow <= 1'b0;
                    green <= 1'b0;
                end
            end
            S2_YELLOW: begin
                yellow <= 1'b1;
                if (red || green) begin
                    red <= 1'b0;
                    green <= 1'b0;
                end
            end
            S3_GREEN: begin
                green <= 1'b1;
                if (red || yellow) begin
                    red <= 1'b0;
                    yellow <= 1'b0;
                end
            end
            default: begin
                red <= 1'b0;
                yellow <= 1'b0;
                green <= 1'b0;
            end
        endcase
    end
end

assign clock = cnt;

endmodule