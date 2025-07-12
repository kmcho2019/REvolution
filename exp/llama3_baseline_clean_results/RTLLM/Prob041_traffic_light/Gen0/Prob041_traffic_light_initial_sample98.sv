module traffic_light(
    input logic rst_n,
    input logic clk,
    input logic pass_request,
    output logic [7:0] clock,
    output logic red,
    output logic yellow,
    output logic green
);

// Define the enumeration values for different states of the traffic light controller
enum logic [1:0] {idle, s1_red, s2_yellow, s3_green} state, next_state;

// Define the registers for the internal counter and the output signals
logic [7:0] cnt;
logic p_red, p_yellow, p_green;

// First always block: State transition logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= idle;
        p_red <= 0;
        p_yellow <= 0;
        p_green <= 0;
    end else begin
        case (state)
            idle: next_state <= s1_red;
            s1_red: next_state <= (cnt == 0) ? s3_green : s1_red;
            s2_yellow: next_state <= (cnt == 0) ? s1_red : s2_yellow;
            s3_green: next_state <= (cnt == 0) ? s2_yellow : s3_green;
            default: next_state <= idle;
        endcase
        state <= next_state;
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

// Second always block: Counting logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt <= 10;
    end else begin
        if (pass_request && p_green) begin
            cnt <= 10;
        end else if (!p_green && (p_green != 0)) begin
            cnt <= 60;
        end else if (!p_yellow && p_yellow) begin
            cnt <= 5;
        end else if (!p_red && p_red) begin
            cnt <= 10;
        end else begin
            cnt <= cnt - 1;
        end
    end
end

// Third always block: Output signal assignment
always @(posedge clk or negedge rst_n) begin
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

// Assign statement: Assign the value of the internal counter (cnt) to the output clock
assign clock = cnt;

endmodule