module traffic_light(
    input rst_n,
    input clk,
    input pass_request,
    output [7:0] clock,
    output red,
    output yellow,
    output green
);

// Define the states of the traffic light controller
parameter idle = 2'b00, red_state = 2'b01, yellow_state = 2'b10, green_state = 2'b11;

// Define the registers and wires
reg [1:0] state;
reg [7:0] cnt;
reg [7:0] next_cnt;

// Hierarchical state machine
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= idle;
    end else begin
        case (state)
            idle: begin
                state <= red_state;
                cnt <= 10;
            end
            red_state: begin
                if (cnt == 0) begin
                    state <= green_state;
                    cnt <= 60;
                end else if (pass_request && cnt > 10) begin
                    cnt <= 10;
                end else begin
                    cnt <= cnt - 1;
                end
            end
            green_state: begin
                if (cnt == 0) begin
                    state <= yellow_state;
                    cnt <= 5;
                end else if (pass_request && cnt > 10) begin
                    cnt <= 10;
                end else begin
                    cnt <= cnt - 1;
                end
            end
            yellow_state: begin
                if (cnt == 0) begin
                    state <= red_state;
                    cnt <= 10;
                end else begin
                    cnt <= cnt - 1;
                end
            end
        endcase
    end
end

// Low-level counter-based module
always @(posedge clk) begin
    if (state == red_state || state == yellow_state || state == green_state) begin
        if (cnt > 0) begin
            cnt <= cnt - 1;
        end
    end
end

// Adaptive timing based on pass_request
always @(posedge clk) begin
    if (pass_request && state == green_state && cnt > 10) begin
        cnt <= 10;
    end
end

// Assign the output signals
assign red = (state == red_state);
assign yellow = (state == yellow_state);
assign green = (state == green_state);
assign clock = cnt;

endmodule