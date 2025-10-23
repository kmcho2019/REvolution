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
reg [1:0] state;
reg [7:0] cnt;

// Initialize the state and counter
initial begin
    state = 2'b00; // red
    cnt = 10;
end

// State transition and counting logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= 2'b00; // red
        cnt <= 10;
        red <= 1;
        yellow <= 0;
        green <= 0;
    end else begin
        case (state)
            2'b00: begin // red
                if (cnt == 0) begin
                    state <= 2'b10; // green
                    cnt <= 60;
                    red <= 0;
                    yellow <= 0;
                    green <= 1;
                end else begin
                    cnt <= cnt - 1;
                    red <= 1;
                    yellow <= 0;
                    green <= 0;
                end
            end
            2'b10: begin // green
                if (cnt == 0) begin
                    state <= 2'b01; // yellow
                    cnt <= 5;
                    red <= 0;
                    yellow <= 1;
                    green <= 0;
                end else if (pass_request && cnt > 10) begin
                    cnt <= 10;
                    red <= 0;
                    yellow <= 0;
                    green <= 1;
                end else begin
                    cnt <= cnt - 1;
                    red <= 0;
                    yellow <= 0;
                    green <= 1;
                end
            end
            2'b01: begin // yellow
                if (cnt == 0) begin
                    state <= 2'b00; // red
                    cnt <= 10;
                    red <= 1;
                    yellow <= 0;
                    green <= 0;
                end else begin
                    cnt <= cnt - 1;
                    red <= 0;
                    yellow <= 1;
                    green <= 0;
                end
            end
        endcase
    end
end

assign clock = cnt;

endmodule