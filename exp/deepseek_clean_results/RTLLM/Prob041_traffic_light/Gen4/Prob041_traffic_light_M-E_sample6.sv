module traffic_light(
    input rst_n,
    input clk,
    input pass_request,
    output [7:0] clock,
    output red,
    output yellow,
    output green
);

// Timing parameters
parameter GREEN_TIME  = 60;
parameter YELLOW_TIME = 5;
parameter RED_TIME    = 10;
parameter MIN_GREEN   = 10;

// State encoding (one-hot)
localparam [2:0] IDLE   = 3'b000,
                 RED    = 3'b100,
                 YELLOW = 3'b010,
                 GREEN  = 3'b001;

reg [2:0] state;
reg [7:0] time_remaining;
reg pedestrian_pending;

// Combined state and timing logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= RED;
        time_remaining <= RED_TIME;
        pedestrian_pending <= 1'b0;
    end else begin
        // Handle pedestrian requests
        if (pass_request && (state == GREEN)) begin
            pedestrian_pending <= 1'b1;
        end

        // State transition and timing logic
        if (time_remaining == 0) begin
            case (state)
                RED: begin
                    state <= GREEN;
                    time_remaining <= GREEN_TIME;
                end
                YELLOW: begin
                    state <= RED;
                    time_remaining <= RED_TIME;
                end
                GREEN: begin
                    state <= YELLOW;
                    time_remaining <= YELLOW_TIME;
                end
                default: begin // IDLE
                    state <= RED;
                    time_remaining <= RED_TIME;
                end
            endcase
            pedestrian_pending <= 1'b0;
        end else begin
            // Handle early transition for pedestrian
            if (pedestrian_pending && (state == GREEN) && 
               (time_remaining > (GREEN_TIME - MIN_GREEN))) begin
                time_remaining <= GREEN_TIME - MIN_GREEN;
                pedestrian_pending <= 1'b0;
            end else begin
                time_remaining <= time_remaining - 1;
            end
        end
    end
end

// Output logic (combinational)
assign red    = state[2];
assign yellow = state[1];
assign green  = state[0];
assign clock  = time_remaining;

endmodule