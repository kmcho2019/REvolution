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

// Define the registers
reg [1:0] state;
reg [7:0] cnt;
reg [7:0] remaining_time;

// State machine
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= idle;
        cnt <= 10;
        remaining_time <= 60;
        red <= 0;
        yellow <= 0;
        green <= 0;
    end else begin
        case (state)
            idle: begin
                state <= red_state;
                cnt <= 10;
                remaining_time <= 60;
                red <= 1;
                yellow <= 0;
                green <= 0;
            end
            red_state: begin
                if (cnt == 0) begin
                    state <= green_state;
                    cnt <= 60;
                    remaining_time <= 60;
                    red <= 0;
                    yellow <= 0;
                    green <= 1;
                end else begin
                    cnt <= cnt - 1;
                end
            end
            green_state: begin
                if (cnt == 0) begin
                    state <= yellow_state;
                    cnt <= 5;
                    remaining_time <= 5;
                    red <= 0;
                    yellow <= 1;
                    green <= 0;
                end else if (pass_request && remaining_time > 10) begin
                    remaining_time <= 10;
                    cnt <= remaining_time;
                end else begin
                    cnt <= cnt - 1;
                    remaining_time <= remaining_time - 1;
                end
            end
            yellow_state: begin
                if (cnt == 0) begin
                    state <= red_state;
                    cnt <= 10;
                    remaining_time <= 60;
                    red <= 1;
                    yellow <= 0;
                    green <= 0;
                end else begin
                    cnt <= cnt - 1;
                    remaining_time <= remaining_time - 1;
                end
            end
            default: begin
                state <= state;
                cnt <= cnt;
            end
        endcase
    end
end

// Assign the value of the internal counter to the output clock
assign clock = cnt;

endmodule