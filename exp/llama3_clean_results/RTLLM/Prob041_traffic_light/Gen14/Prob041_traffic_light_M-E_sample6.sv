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
parameter idle = 2'b00, normal = 2'b01, pedestrian = 2'b10;

// Define the registers
reg [7:0] cnt;
reg [1:0] mode;
reg [1:0] state;

// Top-level state machine
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        mode <= idle;
    end else begin
        case (mode)
            idle: mode <= normal;
            normal: mode <= (pass_request) ? pedestrian : normal;
            pedestrian: mode <= (cnt == 0) ? normal : pedestrian;
            default: mode <= idle;
        endcase
    end
end

// Normal mode state machine
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= idle;
        cnt <= 60;
    end else if (mode == normal) begin
        case (state)
            idle: begin
                state <= normal;
                cnt <= 60;
            end
            normal: begin
                if (cnt == 0) begin
                    state <= yellow;
                    cnt <= 5;
                end else begin
                    cnt <= cnt - 1;
                end
            end
            yellow: begin
                if (cnt == 0) begin
                    state <= red;
                    cnt <= 10;
                end else begin
                    cnt <= cnt - 1;
                end
            end
            red: begin
                if (cnt == 0) begin
                    state <= normal;
                    cnt <= 60;
                end else begin
                    cnt <= cnt - 1;
                end
            end
            default: begin
                state <= idle;
                cnt <= 60;
            end
        endcase
    end
end

// Pedestrian mode state machine
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt <= 10;
    end else if (mode == pedestrian) begin
        if (cnt == 0) begin
            mode <= normal;
        end else begin
            cnt <= cnt - 1;
        end
    end
end

// Assign output signals
assign red = (state == red);
assign yellow = (state == yellow);
assign green = (state == normal);
assign clock = cnt;

endmodule