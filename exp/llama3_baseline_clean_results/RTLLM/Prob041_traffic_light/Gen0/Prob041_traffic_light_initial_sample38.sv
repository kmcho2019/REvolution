module traffic_light(
    input rst_n,
    input clk,
    input pass_request,
    output [7:0] clock,
    output red,
    output yellow,
    output green
);

// Parameters
parameter idle = 2'b00;
parameter s1_red = 2'b01;
parameter s2_yellow = 2'b10;
parameter s3_green = 2'b11;

// Registers
reg [7:0] cnt;
reg [1:0] state;
reg p_red, p_yellow, p_green;

// State transition logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= idle;
        p_red <= 0;
        p_yellow <= 0;
        p_green <= 0;
    end else begin
        case (state)
            idle: state <= s1_red;
            s1_red: if (cnt == 0) state <= s3_green;
            s2_yellow: if (cnt == 0) state <= s1_red;
            s3_green: if (cnt == 0) state <= s2_yellow;
            default: state <= idle;
        endcase
    end
end

// Counting logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt <= 10;
        p_red <= 1;
        p_yellow <= 0;
        p_green <= 0;
    end else begin
        if (pass_request && p_green) cnt <= 10;
        else if (!p_green && p_green) cnt <= 60;
        else if (!p_yellow && p_yellow) cnt <= 5;
        else if (!p_red && p_red) cnt <= 10;
        else if (cnt > 0) cnt <= cnt - 1;
    end
end

// Output logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        red <= 0;
        yellow <= 0;
        green <= 0;
    end else begin
        red <= p_red;
        yellow <= p_yellow;
        green <= p_green;
        
        case (state)
            s1_red: begin
                p_red <= 1;
                p_yellow <= 0;
                p_green <= 0;
            end
            s2_yellow: begin
                p_red <= 0;
                p_yellow <= 1;
                p_green <= 0;
            end
            s3_green: begin
                p_red <= 0;
                p_yellow <= 0;
                p_green <= 1;
            end
            default: begin
                p_red <= 0;
                p_yellow <= 0;
                p_green <= 0;
            end
        endcase
    end
end

// Assign statement
assign clock = cnt;

endmodule