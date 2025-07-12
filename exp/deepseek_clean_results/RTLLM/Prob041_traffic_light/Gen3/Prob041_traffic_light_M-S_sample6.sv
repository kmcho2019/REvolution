module traffic_light(
    input rst_n,
    input clk,
    input pass_request,
    output reg [7:0] clock,
    output reg red,
    output reg yellow,
    output reg green
);

// Timing parameters
parameter GREEN_TIME = 60;
parameter YELLOW_TIME = 5;
parameter RED_TIME = 10;
parameter MIN_GREEN = 10;

// State encoding
parameter RED = 2'b00;
parameter YELLOW = 2'b01;
parameter GREEN = 2'b10;

reg [1:0] state;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= RED;
        clock <= RED_TIME;
        red <= 1'b1;
        yellow <= 1'b0;
        green <= 1'b0;
    end else begin
        // Default outputs
        red <= 1'b0;
        yellow <= 1'b0;
        green <= 1'b0;
        
        // Handle pedestrian request
        if (pass_request && (state == GREEN) && (clock > MIN_GREEN)) begin
            clock <= MIN_GREEN;
        end
        
        // State transitions and counter management
        if (clock == 1) begin
            case (state)
                RED: begin
                    state <= GREEN;
                    clock <= GREEN_TIME;
                end
                YELLOW: begin
                    state <= RED;
                    clock <= RED_TIME;
                end
                GREEN: begin
                    state <= YELLOW;
                    clock <= YELLOW_TIME;
                end
            endcase
        end else begin
            clock <= clock - 1;
        end
        
        // Set current state outputs
        case (state)
            RED:    red <= 1'b1;
            YELLOW: yellow <= 1'b1;
            GREEN:  green <= 1'b1;
        endcase
    end
end

endmodule