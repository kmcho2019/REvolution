module traffic_light(
    input logic rst_n, 
    input logic clk, 
    input logic pass_request, 
    output logic [7:0] clock, 
    output logic red, 
    output logic yellow, 
    output logic green
);

// Define the enumeration values for different states
enum logic [1:0] {idle, s1_red, s2_yellow, s3_green} state, next_state;

// Define the registers for the internal counter and output signals
logic [7:0] cnt;
logic p_red, p_yellow, p_green;

// First always block for state transition logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= idle;
    end else begin
        case (state)
            idle: state <= s1_red;
            s1_red: if (cnt == 0) state <= s3_green; else state <= s1_red;
            s2_yellow: if (cnt == 0) state <= s1_red; else state <= s2_yellow;
            s3_green: if (cnt == 0) state <= s2_yellow; else state <= s3_green;
            default: state <= idle;
        endcase
    end
end

// Second always block for counting logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt <= 10;
    end else begin
        case (state)
            s1_red: if (p_red && !red) cnt <= 10; else cnt <= cnt - 1;
            s2_yellow: if (p_yellow && !yellow) cnt <= 5; else cnt <= cnt - 1;
            s3_green: if (p_green && !green) cnt <= 60; else if (pass_request && green && cnt > 10) cnt <= 10; else cnt <= cnt - 1;
            default: cnt <= cnt - 1;
        endcase
    end
end

// Assign statement for outputting the count value
assign clock = cnt;

// Final always block for output signals
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        p_red <= 0;
        p_yellow <= 0;
        p_green <= 0;
        red <= 0;
        yellow <= 0;
        green <= 0;
    end else begin
        p_red <= red;
        p_yellow <= yellow;
        p_green <= green;
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

endmodule