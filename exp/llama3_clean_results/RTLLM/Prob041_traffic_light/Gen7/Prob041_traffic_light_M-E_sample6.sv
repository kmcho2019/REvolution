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
reg [7:0] cnt_red;
reg [7:0] cnt_yellow;
reg [7:0] cnt_green;
reg [1:0] state;

// State transition logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= idle;
        cnt_red <= 10;
        cnt_yellow <= 5;
        cnt_green <= 60;
        red <= 0;
        yellow <= 0;
        green <= 0;
    end else begin
        case (state)
            idle: begin
                state <= s1_red;
                cnt_red <= 10;
                red <= 1;
                yellow <= 0;
                green <= 0;
            end
            s1_red: begin
                if (cnt_red == 0) begin
                    state <= s3_green;
                    cnt_green <= 60;
                    red <= 0;
                    yellow <= 0;
                    green <= 1;
                end else begin
                    cnt_red <= cnt_red - 1;
                end
            end
            s3_green: begin
                if (cnt_green == 0) begin
                    state <= s2_yellow;
                    cnt_yellow <= 5;
                    red <= 0;
                    yellow <= 1;
                    green <= 0;
                end else if (pass_request && cnt_green > 10) begin
                    cnt_green <= 10;
                end else begin
                    cnt_green <= cnt_green - 1;
                end
            end
            s2_yellow: begin
                if (cnt_yellow == 0) begin
                    state <= s1_red;
                    cnt_red <= 10;
                    red <= 1;
                    yellow <= 0;
                    green <= 0;
                end else begin
                    cnt_yellow <= cnt_yellow - 1;
                end
            end
        endcase
    end
end

// Assign the output signals
assign clock = cnt_green;

endmodule