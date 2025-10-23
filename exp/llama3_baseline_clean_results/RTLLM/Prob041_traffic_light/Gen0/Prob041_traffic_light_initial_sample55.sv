module traffic_light (
    input logic rst_n,
    input logic clk,
    input logic pass_request,
    output logic [7:0] clock,
    output logic red,
    output logic yellow,
    output logic green
);

// Define the states
enum logic [1:0] {idle, s1_red, s2_yellow, s3_green} state, next_state;

// Define the registers for the next values of the signals
logic p_red, p_yellow, p_green;

// Define the internal counter
logic [7:0] cnt;

// State transition logic
always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= idle;
        p_red <= 0;
        p_yellow <= 0;
        p_green <= 0;
    end else begin
        case (state)
            idle: begin
                state <= s1_red;
            end
            s1_red: begin
                if (cnt == 0) begin
                    state <= s3_green;
                end else begin
                    state <= s1_red;
                end
            end
            s2_yellow: begin
                if (cnt == 0) begin
                    state <= s1_red;
                end else begin
                    state <= s2_yellow;
                end
            end
            s3_green: begin
                if (cnt == 0) begin
                    state <= s2_yellow;
                end else if (pass_request && cnt > 10) begin
                    state <= s3_green;
                    cnt <= 10;
                end else begin
                    state <= s3_green;
                end
            end
        endcase
        p_red <= (state == s1_red) ? 1 : 0;
        p_yellow <= (state == s2_yellow) ? 1 : 0;
        p_green <= (state == s3_green) ? 1 : 0;
    end
end

// Counting logic
always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt <= 10;
    end else begin
        case (state)
            s1_red: begin
                if (cnt == 0) begin
                    cnt <= 10;
                end else begin
                    cnt <= cnt - 1;
                end
            end
            s2_yellow: begin
                if (cnt == 0) begin
                    cnt <= 5;
                end else begin
                    cnt <= cnt - 1;
                end
            end
            s3_green: begin
                if (cnt == 0) begin
                    cnt <= 60;
                end else if (pass_request && cnt > 10) begin
                    cnt <= 10;
                end else begin
                    cnt <= cnt - 1;
                end
            end
        endcase
    end
end

// Output signals
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

assign clock = cnt;

endmodule