module traffic_light(
    input rst_n,
    input clk,
    input pass_request,
    output [7:0] clock,
    output red,
    output yellow,
    output green
);

parameter idle = 2'b00;
parameter s1_red = 2'b01;
parameter s2_yellow = 2'b10;
parameter s3_green = 2'b11;

reg [7:0] cnt;
reg [1:0] state;
reg p_red, p_yellow, p_green;

always @(*) begin
    case (state)
        idle: state = s1_red;
        s1_red: if (cnt == 0) state = s3_green; else state = s1_red;
        s2_yellow: if (cnt == 0) state = s1_red; else state = s2_yellow;
        s3_green: 
            if (cnt == 0) state = s2_yellow; 
            else if (pass_request && p_green) state = s2_yellow; 
            else state = s3_green;
        default: state = idle;
    endcase
end

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt <= 10;
        state <= idle;
        p_red <= 0;
        p_yellow <= 0;
        p_green <= 0;
    end else begin
        if (pass_request && p_green && cnt > 10) cnt <= 10;
        else if (!p_green && p_green!= green) cnt <= (green? 60 : (yellow? 5 : 10));
        else if (cnt > 0) cnt <= cnt - 1;
        
        p_red <= red;
        p_yellow <= yellow;
        p_green <= green;
    end
end

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        red <= 0;
        yellow <= 0;
        green <= 0;
    end else begin
        case (state)
            idle: begin
                red <= 0;
                yellow <= 0;
                green <= 0;
            end
            s1_red: begin
                red <= 1;
                yellow <= 0;
                green <= 0;
            end
            s2_yellow: begin
                red <= 0;
                yellow <= 1;
                green <= 0;
            end
            s3_green: begin
                red <= 0;
                yellow <= 0;
                green <= 1;
            end
            default: begin
                red <= 0;
                yellow <= 0;
                green <= 0;
            end
        endcase
    end
end

assign clock = cnt;

endmodule