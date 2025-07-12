module traffic_light(
    input rst_n,
    input clk,
    input pass_request,
    output [7:0] clock,
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
localparam IDLE = 2'b00;
localparam RED = 2'b01;
localparam YELLOW = 2'b10;
localparam GREEN = 2'b11;

reg [1:0] state;
reg [7:0] cnt;

// Combined state and output logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= IDLE;
        cnt <= RED_TIME;
        red <= 1'b0;
        yellow <= 1'b0;
        green <= 1'b0;
    end else begin
        // Handle pedestrian request
        if (pass_request && (state == GREEN) && (cnt > MIN_GREEN))
            cnt <= MIN_GREEN;
        
        // Counter and state logic
        if (cnt == 1) begin
            case (state)
                IDLE: begin
                    state <= RED;
                    cnt <= RED_TIME;
                end
                RED: begin
                    state <= GREEN;
                    cnt <= GREEN_TIME;
                end
                YELLOW: begin
                    state <= RED;
                    cnt <= RED_TIME;
                end
                GREEN: begin
                    state <= YELLOW;
                    cnt <= YELLOW_TIME;
                end
            endcase
        end else begin
            cnt <= cnt - 1;
        end
        
        // Output logic
        red <= (state == RED);
        yellow <= (state == YELLOW);
        green <= (state == GREEN);
    end
end

assign clock = cnt;

endmodule