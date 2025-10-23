module traffic_light(
    input logic rst_n, clk, pass_request,
    output logic [7:0] clock,
    output logic red, yellow, green
);

// Parameters
parameter idle = 2'b00;
parameter s1_red = 2'b01;
parameter s2_yellow = 2'b10;
parameter s3_green = 2'b11;

// Registers and Wires
reg [7:0] cnt;
reg [1:0] state;
reg p_red, p_yellow, p_green;

// State Transition Logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= idle;
    end else begin
        case (state)
            idle: state <= s1_red;
            s1_red: if (cnt == 0) state <= s3_green;
            s2_yellow: if (cnt == 0) state <= s1_red;
            s3_green: if (cnt == 0) state <= s2_yellow;
            default: state <= state;
        endcase
    end
end

// Counting Logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt <= 10;
    end else begin
        if (state == s1_red) begin
            if (cnt > 0) cnt <= cnt - 1;
            else cnt <= 10;
        end else if (state == s2_yellow) begin
            if (cnt > 0) cnt <= cnt - 1;
            else cnt <= 5;
        end else if (state == s3_green) begin
            if (cnt > 0) cnt <= cnt - 1;
            else cnt <= 60;
        end
        if (pass_request && p_green) begin
            if (cnt > 10) cnt <= 10;
        end
    end
end

// Output Signals
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        p_red <= 0;
        p_yellow <= 0;
        p_green <= 0;
    end else begin
        case (state)
            idle: begin
                p_red <= 0;
                p_yellow <= 0;
                p_green <= 0;
            end
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
                p_red <= p_red;
                p_yellow <= p_yellow;
                p_green <= p_green;
            end
        endcase
    end
end

// Assign Output Signals
assign red = p_red;
assign yellow = p_yellow;
assign green = p_green;
assign clock = cnt;

endmodule