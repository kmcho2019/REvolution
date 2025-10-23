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
reg [7:0] cnt_red, cnt_yellow, cnt_green;
reg [1:0] state, next_state;
reg pedestrian_request;

// Traffic Light Controller Module
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
        state <= next_state;
        case (state)
            s1_red: begin
                red <= 1;
                yellow <= 0;
                green <= 0;
                if (cnt_red == 0) begin
                    state <= s3_green;
                    cnt_green <= 60;
                end else begin
                    cnt_red <= cnt_red - 1;
                end
            end
            s2_yellow: begin
                red <= 0;
                yellow <= 1;
                green <= 0;
                if (cnt_yellow == 0) begin
                    state <= s1_red;
                    cnt_red <= 10;
                end else begin
                    cnt_yellow <= cnt_yellow - 1;
                end
            end
            s3_green: begin
                red <= 0;
                yellow <= 0;
                green <= 1;
                if (cnt_green == 0) begin
                    state <= s2_yellow;
                    cnt_yellow <= 5;
                end else if (pedestrian_request && cnt_green > 10) begin
                    cnt_green <= 10;
                end else begin
                    cnt_green <= cnt_green - 1;
                end
            end
            default: begin
                red <= 0;
                yellow <= 0;
                green <= 0;
            end
        endcase
    end
end

// Pedestrian Request Handler Module
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        pedestrian_request <= 0;
    end else begin
        if (pass_request) begin
            pedestrian_request <= 1;
        end else begin
            pedestrian_request <= 0;
        end
    end
end

// Timer Module
assign clock = (state == s1_red) ? cnt_red :
               (state == s2_yellow) ? cnt_yellow :
               (state == s3_green) ? cnt_green : 0;

endmodule