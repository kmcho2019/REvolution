module traffic_light(
    input rst_n,
    input clk,
    input pass_request,
    output [7:0] clock,
    output red,
    output yellow,
    output green
);

// Timer module
reg [7:0] cnt;
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt <= 8'd60; // initial value for green light
    end else if (cnt == 0) begin
        case ({red, yellow, green})
            3'b001: cnt <= 8'd5; // transition from green to yellow
            3'b010: cnt <= 8'd10; // transition from yellow to red
            3'b100: cnt <= 8'd60; // transition from red to green
            default: cnt <= 8'd60;
        endcase
    end else begin
        cnt <= cnt - 1;
    end
end

// Pedestrian Request Handler module
reg [7:0] pedestrian_cnt;
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        pedestrian_cnt <= 8'd0;
    end else if (pass_request && green && cnt > 10) begin
        pedestrian_cnt <= 8'd10;
    end else if (pedestrian_cnt > 0) begin
        pedestrian_cnt <= pedestrian_cnt - 1;
    end
end

// Traffic Light Controller module
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        red <= 1'b1;
        yellow <= 1'b0;
        green <= 1'b0;
    end else if (cnt == 0) begin
        case ({red, yellow, green})
            3'b001: begin // transition from green to yellow
                red <= 1'b0;
                yellow <= 1'b1;
                green <= 1'b0;
            end
            3'b010: begin // transition from yellow to red
                red <= 1'b1;
                yellow <= 1'b0;
                green <= 1'b0;
            end
            3'b100: begin // transition from red to green
                red <= 1'b0;
                yellow <= 1'b0;
                green <= 1'b1;
            end
            default: begin
                red <= 1'b1;
                yellow <= 1'b0;
                green <= 1'b0;
            end
        endcase
    end else if (pedestrian_cnt > 0) begin
        red <= 1'b0;
        yellow <= 1'b0;
        green <= 1'b1;
    end
end

assign clock = cnt;

endmodule