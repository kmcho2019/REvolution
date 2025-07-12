module traffic_light(
    input logic rst_n,
    input logic clk,
    input logic pass_request,
    output logic [7:0] clock,
    output logic red,
    output logic yellow,
    output logic green
);

// Define enumeration values for different states
enum logic [1:0] {idle, s1_red, s2_yellow, s3_green} state, next_state;

// Define registers for internal counter and previous output values
logic [7:0] cnt;
logic p_red, p_yellow, p_green;

// First always block: State transition logic
always_ff @(posedge clk or negedge rst_n) begin
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

// Second always block: Counting logic
always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt <= 10;
        p_red <= 1'b0;
        p_yellow <= 1'b0;
        p_green <= 1'b0;
    end else begin
        case (state)
            s1_red: begin
                if (pass_request && p_green) cnt <= 10;
                else if (!p_red && red) cnt <= 10;
                else cnt <= cnt - 1;
            end
            s2_yellow: begin
                if (!p_yellow && yellow) cnt <= 5;
                else cnt <= cnt - 1;
            end
            s3_green: begin
                if (pass_request && p_green && cnt > 10) cnt <= 10;
                else if (!p_green && green) cnt <= 60;
                else cnt <= cnt - 1;
            end
            default: cnt <= cnt;
        endcase
    end
end

// Third always block: Output signals
always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        red <= 1'b0;
        yellow <= 1'b0;
        green <= 1'b0;
    end else begin
        case (state)
            s1_red: begin
                p_red <= 1'b1;
                p_yellow <= 1'b0;
                p_green <= 1'b0;
            end
            s2_yellow: begin
                p_red <= 1'b0;
                p_yellow <= 1'b1;
                p_green <= 1'b0;
            end
            s3_green: begin
                p_red <= 1'b0;
                p_yellow <= 1'b0;
                p_green <= 1'b1;
            end
            default: begin
                p_red <= p_red;
                p_yellow <= p_yellow;
                p_green <= p_green;
            end
        endcase
        red <= p_red;
        yellow <= p_yellow;
        green <= p_green;
    end
end

// Assign statement: Internal counter to output clock
assign clock = cnt;

endmodule