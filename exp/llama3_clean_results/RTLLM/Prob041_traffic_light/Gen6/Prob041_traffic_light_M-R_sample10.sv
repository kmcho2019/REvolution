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
reg [1:0] state;
reg [7:0] cnt;
reg p_green;

// State transition logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= idle;
    end else begin
        case (state)
            idle: state <= s1_red;
            s1_red: if (cnt == 0) state <= s3_green;
            s3_green: if (cnt == 0) state <= s2_yellow;
            s2_yellow: if (cnt == 0) state <= s1_red;
        endcase
    end
end

// Counting logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt <= 10;
        p_green <= 0;
    end else begin
        case (state)
            s1_red: begin
                if (cnt == 0) cnt <= 10;
                else cnt <= cnt - 1;
            end
            s3_green: begin
                if (pass_request && cnt > 10) cnt <= 10;
                if (cnt == 0) cnt <= 5;
                else cnt <= cnt - 1;
                p_green <= 1;
            end
            s2_yellow: begin
                if (cnt == 0) cnt <= 60;
                else cnt <= cnt - 1;
                p_green <= 0;
            end
        endcase
    end
end

// Output signal assignments
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        red <= 0;
        yellow <= 0;
        green <= 0;
    end else begin
        case (state)
            s1_red: begin
                red <= 1;
                yellow <= 0;
                green <= 0;
            end
            s3_green: begin
                red <= 0;
                yellow <= 0;
                green <= 1;
            end
            s2_yellow: begin
                red <= 0;
                yellow <= 1;
                green <= 0;
            end
        endcase
    end
end

assign clock = cnt;

endmodule