module traffic_light (
    input  logic rst_n, clk, pass_request,
    output logic [7:0] clock,
    output logic red, yellow, green
);

// Parameters for states
parameter idle = 2'b00, s1_red = 2'b01, s2_yellow = 2'b10, s3_green = 2'b11;

// Registers and wires
logic [7:0] cnt;
logic [1:0] state, p_state;
logic p_red, p_yellow, p_green;
logic red_next, yellow_next, green_next;

// State transition logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= idle;
        p_red <= 0;
        p_yellow <= 0;
        p_green <= 0;
    end
    else begin
        case (state)
            idle: begin
                state <= s1_red;
                p_red <= 1;
                p_yellow <= 0;
                p_green <= 0;
            end
            s1_red: begin
                if (cnt == 0) begin
                    state <= s3_green;
                    p_red <= 0;
                    p_yellow <= 0;
                    p_green <= 1;
                end
                else begin
                    state <= s1_red;
                    p_red <= 1;
                    p_yellow <= 0;
                    p_green <= 0;
                end
            end
            s2_yellow: begin
                if (cnt == 0) begin
                    state <= s1_red;
                    p_red <= 1;
                    p_yellow <= 0;
                    p_green <= 0;
                end
                else begin
                    state <= s2_yellow;
                    p_red <= 0;
                    p_yellow <= 1;
                    p_green <= 0;
                end
            end
            s3_green: begin
                if (cnt == 0) begin
                    state <= s2_yellow;
                    p_red <= 0;
                    p_yellow <= 1;
                    p_green <= 0;
                end
                else begin
                    state <= s3_green;
                    p_red <= 0;
                    p_yellow <= 0;
                    p_green <= 1;
                end
            end
        endcase
    end
end

// Counting logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt <= 10;
    end
    else begin
        if (pass_request && p_green) begin
            cnt <= 10;
        end
        else if (p_green == 0 && p_state == s3_green) begin
            cnt <= 60;
        end
        else if (p_yellow == 0 && p_state == s2_yellow) begin
            cnt <= 5;
        end
        else if (p_red == 0 && p_state == s1_red) begin
            cnt <= 10;
        end
        else if (cnt > 0) begin
            cnt <= cnt - 1;
        end
        else begin
            cnt <= cnt;
        end
    end
end

// Output signals
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        red <= 0;
        yellow <= 0;
        green <= 0;
        p_state <= idle;
    end
    else begin
        red <= p_red;
        yellow <= p_yellow;
        green <= p_green;
        p_state <= state;
    end
end

// Assign counter value to output clock
assign clock = cnt;

endmodule