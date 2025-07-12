module traffic_light(
    input rst_n,
    input clk,
    input pass_request,
    output reg [7:0] clock,
    output reg red,
    output reg yellow,
    output reg green
);

// Parameters for timing
parameter RED_TIME    = 8'd10;
parameter YELLOW_TIME = 8'd5;
parameter GREEN_TIME  = 8'd60;
parameter MIN_GREEN   = 8'd10;

// State encoding
typedef enum logic [1:0] {
    IDLE,
    RED,
    YELLOW,
    GREEN
} state_t;

state_t state;
reg [7:0] cnt;

// Single always block for state and counter logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= RED;
        cnt <= RED_TIME;
        red <= 1;
        yellow <= 0;
        green <= 0;
    end else begin
        // Default outputs
        red <= 0;
        yellow <= 0;
        green <= 0;
        
        // State machine and counter logic
        case (state)
            RED: begin
                red <= 1;
                if (cnt == 1) begin
                    state <= GREEN;
                    cnt <= GREEN_TIME;
                end else begin
                    cnt <= cnt - 1;
                end
            end
            
            YELLOW: begin
                yellow <= 1;
                if (cnt == 1) begin
                    state <= RED;
                    cnt <= RED_TIME;
                end else begin
                    cnt <= cnt - 1;
                end
            end
            
            GREEN: begin
                green <= 1;
                if (pass_request && cnt > MIN_GREEN) begin
                    cnt <= MIN_GREEN;
                end else if (cnt == 1) begin
                    state <= YELLOW;
                    cnt <= YELLOW_TIME;
                end else begin
                    cnt <= cnt - 1;
                end
            end
            
            default: begin // IDLE
                state <= RED;
                cnt <= RED_TIME;
            end
        endcase
    end
    clock <= cnt;
end

endmodule