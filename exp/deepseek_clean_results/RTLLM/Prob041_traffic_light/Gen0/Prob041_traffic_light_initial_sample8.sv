module traffic_light(
    input rst_n,
    input clk,
    input pass_request,
    output reg [7:0] clock,
    output reg red,
    output reg yellow,
    output reg green
);

// State encoding
parameter idle    = 2'b00;
parameter s1_red  = 2'b01;
parameter s2_yellow = 2'b10;
parameter s3_green = 2'b11;

reg [1:0] state;
reg [1:0] next_state;
reg [7:0] cnt;
reg p_red, p_yellow, p_green;

// State transition logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= idle;
    end else begin
        state <= next_state;
    end
end

// Next state logic
always @(*) begin
    case (state)
        idle: next_state = s1_red;
        s1_red: next_state = (cnt == 0) ? s3_green : s1_red;
        s2_yellow: next_state = (cnt == 0) ? s1_red : s2_yellow;
        s3_green: next_state = (cnt == 0) ? s2_yellow : s3_green;
        default: next_state = idle;
    endcase
end

// Counter logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt <= 10;
    end else begin
        case (state)
            idle: cnt <= 10;
            s1_red: begin
                if (cnt == 0)
                    cnt <= 60;
                else
                    cnt <= cnt - 1;
            end
            s2_yellow: begin
                if (cnt == 0)
                    cnt <= 10;
                else
                    cnt <= cnt - 1;
            end
            s3_green: begin
                if (pass_request && green && (cnt > 10))
                    cnt <= 10;
                else if (cnt == 0)
                    cnt <= 5;
                else
                    cnt <= cnt - 1;
            end
            default: cnt <= 10;
        endcase
    end
end

// Output logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        p_red <= 0;
        p_yellow <= 0;
        p_green <= 0;
    end else begin
        p_red <= (state == s1_red);
        p_yellow <= (state == s2_yellow);
        p_green <= (state == s3_green);
    end
end

// Register outputs
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        red <= 0;
        yellow <= 0;
        green <= 0;
        clock <= 0;
    end else begin
        red <= p_red;
        yellow <= p_yellow;
        green <= p_green;
        clock <= cnt;
    end
end

endmodule