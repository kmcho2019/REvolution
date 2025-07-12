module traffic_light_controller(
    input rst_n,
    input clk,
    input pass_request,
    output [7:0] clock,
    output red,
    output yellow,
    output green
);

// Define the states of the traffic light controller
parameter idle = 3'b001, red_phase = 3'b010, yellow_phase = 3'b100, green_phase = 3'b011;

// Define the registers and wires
reg [2:0] state;
reg [7:0] cnt;

// State transition logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= idle;
    end else begin
        case (state)
            idle: begin
                state <= red_phase;
            end
            red_phase: begin
                if (cnt == 0) begin
                    state <= green_phase;
                end
            end
            green_phase: begin
                if (cnt == 0) begin
                    if (pass_request) begin
                        state <= yellow_phase;
                    end else begin
                        state <= red_phase;
                    end
                end else if (pass_request && cnt > 10) begin
                    cnt <= 10;
                end
            end
            yellow_phase: begin
                if (cnt == 0) begin
                    state <= red_phase;
                end
            end
        endcase
    end
end

// Counter logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt <= 60;
    end else begin
        case (state)
            idle: begin
                cnt <= 10;
            end
            red_phase: begin
                cnt <= 10;
            end
            green_phase: begin
                if (cnt > 0) begin
                    cnt <= cnt - 1;
                end
            end
            yellow_phase: begin
                cnt <= 5;
            end
        endcase
    end
end

// Output logic
assign red = (state == red_phase);
assign yellow = (state == yellow_phase);
assign green = (state == green_phase);
assign clock = cnt;

endmodule