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
parameter red_state = 2'b00, yellow_state = 2'b01, green_state = 2'b10;

// Define the registers and wires
reg [7:0] cnt;
reg [1:0] state, next_state;

// State transition logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= red_state;
        cnt <= 10;
        red <= 1;
        yellow <= 0;
        green <= 0;
    end else begin
        state <= next_state;
        case (state)
            red_state: begin
                if (cnt == 0) begin
                    cnt <= 60;
                    state <= green_state;
                end else begin
                    cnt <= cnt - 1;
                end
            end
            yellow_state: begin
                if (cnt == 0) begin
                    cnt <= 10;
                    state <= red_state;
                end else begin
                    cnt <= cnt - 1;
                end
            end
            green_state: begin
                if (cnt == 0 || (pass_request && cnt > 10)) begin
                    cnt <= 10;
                    state <= yellow_state;
                end else begin
                    cnt <= cnt - 1;
                end
            end
        endcase
        case (state)
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
        endcase
    end
end

// Assign the output clock
assign clock = cnt;

endmodule