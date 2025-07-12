module traffic_light(
    input rst_n,
    input clk,
    input pass_request,
    output [7:0] clock,
    output reg red,
    output reg yellow,
    output reg green
);

// Define the states of the traffic light controller
parameter idle = 2'b00, red_state = 2'b01, yellow_state = 2'b10, green_state = 2'b11;

// Define the states of the pedestrian request sub-FSM
parameter pedestrian_request_idle = 2'b00, pedestrian_request_active = 2'b01;

// Define the registers and wires
reg [7:0] cnt;
reg [1:0] state, next_state;
reg [1:0] pedestrian_request_state, next_pedestrian_request_state;

// Top-level FSM state transition logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= idle;
        cnt <= 0;
        red <= 0;
        yellow <= 0;
        green <= 0;
        pedestrian_request_state <= pedestrian_request_idle;
    end else begin
        state <= next_state;
        pedestrian_request_state <= next_pedestrian_request_state;
        case (state)
            idle: begin
                red <= 0;
                yellow <= 0;
                green <= 0;
            end
            red_state: begin
                red <= 1;
                yellow <= 0;
                green <= 0;
            end
            yellow_state: begin
                red <= 0;
                yellow <= 1;
                green <= 0;
            end
            green_state: begin
                red <= 0;
                yellow <= 0;
                green <= 1;
            end
            default: begin
                red <= 0;
                yellow <= 0;
                green <= 0;
            end
        endcase
        case (pedestrian_request_state)
            pedestrian_request_idle: begin
                if (pass_request && state == green_state) begin
                    pedestrian_request_state <= pedestrian_request_active;
                    cnt <= 10;
                end
            end
            pedestrian_request_active: begin
                if (cnt == 0) begin
                    pedestrian_request_state <= pedestrian_request_idle;
                end
            end
            default: begin
                pedestrian_request_state <= pedestrian_request_idle;
            end
        endcase
        if (cnt == 0) begin
            case (state)
                idle: begin
                    state <= red_state;
                    cnt <= 10;
                end
                red_state: begin
                    state <= green_state;
                    cnt <= 60;
                end
                yellow_state: begin
                    state <= red_state;
                    cnt <= 10;
                end
                green_state: begin
                    if (pedestrian_request_state == pedestrian_request_active) begin
                        state <= yellow_state;
                        cnt <= 5;
                    end else begin
                        state <= yellow_state;
                        cnt <= 5;
                    end
                end
                default: begin
                    state <= idle;
                end
            endcase
        end else begin
            cnt <= cnt - 1;
        end
    end
end

// Assign the output clock
assign clock = cnt;

endmodule