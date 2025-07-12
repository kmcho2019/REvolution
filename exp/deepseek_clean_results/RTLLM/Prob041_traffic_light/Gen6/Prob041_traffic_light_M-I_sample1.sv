module traffic_light(
    input rst_n,
    input clk,
    input pass_request,
    output [5:0] clock,  // Reduced from 8 to 6 bits
    output reg red,
    output reg yellow,
    output reg green
);

// Timing parameters
parameter RED_TIME   = 6'd10;
parameter YELLOW_TIME = 6'd5;
parameter GREEN_TIME = 6'd60;
parameter MIN_GREEN  = 6'd10;

// One-hot state encoding
localparam [3:0] 
    IDLE  = 4'b0001,
    RED_S = 4'b0010,
    YELLOW_S = 4'b0100,
    GREEN_S = 4'b1000;

// Internal signals
reg [5:0] cnt;  // 6-bit counter
reg [3:0] state;
reg [1:0] pass_sync;  // For debouncing

// Pass request synchronization
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) pass_sync <= 2'b00;
    else pass_sync <= {pass_sync[0], pass_request};
end

wire pass_req_valid = (pass_sync == 2'b01);

// State and counter logic with integrated output generation
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= IDLE;
        cnt <= RED_TIME;
        {red, yellow, green} <= 3'b000;
    end else begin
        // Default outputs (clock gated during IDLE)
        if (state != IDLE) begin
            red <= (state == RED_S);
            yellow <= (state == YELLOW_S);
            green <= (state == GREEN_S);
        end else begin
            {red, yellow, green} <= 3'b000;
        end

        case (state)
            IDLE: begin
                state <= RED_S;
                cnt <= RED_TIME;
            end
            
            RED_S: begin
                if (cnt == 1) begin
                    state <= GREEN_S;
                    cnt <= GREEN_TIME;
                end else begin
                    cnt <= cnt - 1;
                end
            end
            
            YELLOW_S: begin
                if (cnt == 1) begin
                    state <= RED_S;
                    cnt <= RED_TIME;
                end else begin
                    cnt <= cnt - 1;
                end
            end
            
            GREEN_S: begin
                // Handle synchronized pedestrian request
                if (pass_req_valid && (cnt > MIN_GREEN)) begin
                    cnt <= MIN_GREEN;
                end
                // Normal countdown
                else if (cnt == 1) begin
                    state <= YELLOW_S;
                    cnt <= YELLOW_TIME;
                end else begin
                    cnt <= cnt - 1;
                end
            end
            
            default: begin
                state <= IDLE;
                cnt <= RED_TIME;
            end
        endcase
    end
end

assign clock = cnt;

endmodule