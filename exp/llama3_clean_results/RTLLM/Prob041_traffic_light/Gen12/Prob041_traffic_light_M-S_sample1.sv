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
parameter idle = 2'b00, s1_red = 2'b01, s2_yellow = 2'b10, s3_green = 2'b11;

// Define the registers and wires
reg [7:0] cnt;
reg [1:0] state;

// State transition logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= idle;
        cnt <= 10;
        red <= 0;
        yellow <= 0;
        green <= 0;
    end else begin
        case (state)
            idle: begin
                state <= s1_red;
                cnt <= 60;
                red <= 1;
                yellow <= 0;
                green <= 0;
            end
            s1_red: begin
                if (cnt == 0) begin
                    state <= s3_green;
                    cnt <= 60;
                end else if (pass_request && cnt > 10) begin
                    cnt <= 10;
                end else begin
                    cnt <= cnt - 1;
                end
                red <= 1;
                yellow <= 0;
                green <= 0;
            end
            s3_green: begin
                if (cnt == 0) begin
                    state <= s2_yellow;
                    cnt <= 5;
                end else if (pass_request && cnt > 10) begin
                    cnt <= 10;
                end else begin
                    cnt <= cnt - 1;
                end
                red <= 0;
                yellow <= 0;
                green <= 1;
            end
            s2_yellow: begin
                if (cnt == 0) begin
                    state <= s1_red;
                    cnt <= 10;
                end else begin
                    cnt <= cnt - 1;
                end
                red <= 0;
                yellow <= 1;
                green <= 0;
            end
            default: begin
                state <= idle;
                cnt <= 10;
                red <= 0;
                yellow <= 0;
                green <= 0;
            end
        endcase
    end
end

// Assign the output clock
assign clock = cnt;

endmodule