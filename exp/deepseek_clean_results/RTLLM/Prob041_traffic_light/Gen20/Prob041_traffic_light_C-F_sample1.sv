module traffic_light(
    input rst_n,
    input clk,
    input pass_request,
    output [5:0] clock,
    output red,
    output yellow,
    output green
);

// Fixed timing parameters
localparam GREEN_TIME  = 60;
localparam YELLOW_TIME = 5;
localparam RED_TIME    = 10;
localparam MIN_GREEN   = 10;

// State encoding
reg [1:0] state;
reg [5:0] cnt;

// State definitions
localparam S_RED    = 2'b00;
localparam S_YELLOW = 2'b01;
localparam S_GREEN  = 2'b10;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Reset to RED state with full count
        state <= S_RED;
        cnt <= RED_TIME;
    end else begin
        // Default counter decrement
        cnt <= cnt - 1;
        
        // Handle state transitions and special cases
        case (state)
            S_RED: begin
                if (cnt == 0) begin
                    state <= S_GREEN;
                    cnt <= GREEN_TIME;
                end
            end
            
            S_YELLOW: begin
                if (cnt == 0) begin
                    state <= S_RED;
                    cnt <= RED_TIME;
                end
            end
            
            S_GREEN: begin
                // Handle pedestrian request
                if (pass_request && cnt > MIN_GREEN) begin
                    cnt <= MIN_GREEN;
                end
                // State transition
                else if (cnt == 0) begin
                    state <= S_YELLOW;
                    cnt <= YELLOW_TIME;
                end
            end
        endcase
    end
end

// Direct output assignments
assign red    = (state == S_RED);
assign yellow = (state == S_YELLOW);
assign green  = (state == S_GREEN);
assign clock  = cnt;

endmodule