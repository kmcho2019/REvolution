module traffic_light(
    input logic rst_n, clk, pass_request,
    output logic [7:0] clock,
    output logic red, yellow, green
);

// Define the states of the traffic light controller
enum logic [1:0] {idle, s1_red, s2_yellow, s3_green} state, next_state;

// Define the registers for the output signals
logic p_red, p_yellow, p_green;

// Define the internal counter
logic [7:0] cnt;

// First always block: State transition logic
always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= idle;
        p_red <= 0;
        p_yellow <= 0;
        p_green <= 0;
    end else begin
        case (state)
            idle: begin
                next_state <= s1_red;
            end
            s1_red: begin
                if (cnt == 0) begin
                    next_state <= s3_green;
                end else begin
                    next_state <= s1_red;
                end
            end
            s2_yellow: begin
                if (cnt == 0) begin
                    next_state <= s1_red;
                end else begin
                    next_state <= s2_yellow;
                end
            end
            s3_green: begin
                if (cnt == 0) begin
                    next_state <= s2_yellow;
                end else begin
                    next_state <= s3_green;
                end
            end
            default: begin
                next_state <= idle;
            end
        endcase
        state <= next_state;
        if (state == s1_red) begin
            p_red <= 1;
            p_yellow <= 0;
            p_green <= 0;
        end else if (state == s2_yellow) begin
            p_red <= 0;
            p_yellow <= 1;
            p_green <= 0;
        end else if (state == s3_green) begin
            p_red <= 0;
            p_yellow <= 0;
            p_green <= 1;
        end else begin
            p_red <= 0;
            p_yellow <= 0;
            p_green <= 0;
        end
    end
end

// Second always block: Counting logic
always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt <= 10;
    end else begin
        if (pass_request && p_green) begin
            if (cnt > 10) begin
                cnt <= 10;
            end else begin
                cnt <= cnt;
            end
        end else if (!p_green && p_green != 1'bz) begin
            if (p_green == 1'b1) begin
                cnt <= 60;
            end else if (p_yellow == 1'b1) begin
                cnt <= 5;
            end else if (p_red == 1'b1) begin
                cnt <= 10;
            end else begin
                cnt <= cnt;
            end
        end else begin
            if (cnt != 0) begin
                cnt <= cnt - 1;
            end else begin
                cnt <= cnt;
            end
        end
    end
end

// Assign statement: Assign the value of the internal counter to the output clock
assign clock = cnt;

// Third always block: Output signals
always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        red <= 0;
        yellow <= 0;
        green <= 0;
    end else begin
        red <= p_red;
        yellow <= p_yellow;
        green <= p_green;
    end
end

endmodule