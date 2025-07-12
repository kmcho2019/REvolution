module traffic_light(
    input rst_n,
    input clk,
    input pass_request,
    output [5:0] clock,  // Reduced from 8 to 6 bits
    output reg red,
    output reg yellow,
    output reg green
);

// One-hot state encoding
parameter IDLE     = 3'b000;
parameter S1_RED   = 3'b001;
parameter S2_YELLOW = 3'b010;
parameter S3_GREEN = 3'b100;

reg [2:0] state;
reg [5:0] cnt;  // Reduced from 8 to 6 bits
reg prev_green;

// State transition logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= IDLE;
        cnt <= 6'd10;
        {red, yellow, green} <= 3'b000;
        prev_green <= 1'b0;
    end else begin
        prev_green <= green;
        
        case (state)
            IDLE: begin
                state <= S1_RED;
                cnt <= 6'd10;
            end
            
            S1_RED: begin
                if (cnt == 6'd1) begin
                    state <= S3_GREEN;
                    cnt <= 6'd60;
                end else begin
                    cnt <= cnt - 6'd1;
                end
            end
            
            S2_YELLOW: begin
                if (cnt == 6'd1) begin
                    state <= S1_RED;
                    cnt <= 6'd10;
                end else begin
                    cnt <= cnt - 6'd1;
                end
            end
            
            S3_GREEN: begin
                // Handle pedestrian request
                if (pass_request && (cnt > 6'd10)) begin
                    cnt <= 6'd10;
                end
                if (cnt == 6'd1) begin
                    state <= S2_YELLOW;
                    cnt <= 6'd5;
                end else begin
                    cnt <= cnt - 6'd1;
                end
            end
            
            default: state <= IDLE;
        endcase
        
        // Output assignments with hold conditions
        if (state != IDLE) begin
            red <= (state == S1_RED);
            yellow <= (state == S2_YELLOW);
            green <= (state == S3_GREEN);
        end
    end
end

assign clock = cnt;

endmodule