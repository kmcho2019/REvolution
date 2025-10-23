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
parameter idle = 3'b001, red = 3'b010, yellow = 3'b100, green = 3'b000;

// Define the registers and wires
reg [2:0] state;
reg [7:0] cnt;
reg enable_cnt;

// State transition logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= idle;
        cnt <= 10;
    end else begin
        case (state)
            idle: begin
                state <= red;
                cnt <= 10;
            end
            red: begin
                if (cnt == 0) begin
                    state <= green;
                    cnt <= 60;
                end else if (pass_request && state == green) begin
                    cnt <= 10;
                end else begin
                    cnt <= cnt - 1;
                end
            end
            green: begin
                if (cnt == 0) begin
                    state <= yellow;
                    cnt <= 5;
                end else if (pass_request && state == green) begin
                    cnt <= 10;
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
        endcase
    end
end

// Counter module
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt <= 10;
    end else if (enable_cnt) begin
        cnt <= cnt - 1;
    end
end

// Assign the output signals
assign red = (state == red) ? 1'b1 : 1'b0;
assign yellow = (state == yellow) ? 1'b1 : 1'b0;
assign green = (state == green) ? 1'b1 : 1'b0;
assign clock = cnt;
assign enable_cnt = (state == red || state == yellow || state == green) ? 1'b1 : 1'b0;

endmodule