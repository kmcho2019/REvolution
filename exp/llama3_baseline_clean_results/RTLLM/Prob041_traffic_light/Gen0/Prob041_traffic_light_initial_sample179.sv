module traffic_light(
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

// Define the registers
logic [7:0] cnt;
logic p_red, p_yellow, p_green;

// State transition logic
always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= idle;
        p_red <= 1'b0;
        p_yellow <= 1'b0;
        p_green <= 1'b0;
    end else begin
        state <= next_state;
        p_red <= red;
        p_yellow <= yellow;
        p_green <= green;
    end
end

always_comb begin
    case (state)
        idle: begin
            next_state = s1_red;
            red = 1'b0;
            yellow = 1'b0;
            green = 1'b0;
        end
        s1_red: begin
            next_state = (cnt == 0) ? s3_green : s1_red;
            red = 1'b1;
            yellow = 1'b0;
            green = 1'b0;
        end
        s2_yellow: begin
            next_state = (cnt == 0) ? s1_red : s2_yellow;
            red = 1'b0;
            yellow = 1'b1;
            green = 1'b0;
        end
        s3_green: begin
            next_state = (cnt == 0) ? s2_yellow : s3_green;
            red = 1'b0;
            yellow = 1'b0;
            green = 1'b1;
        end
        default: begin
            next_state = idle;
            red = 1'b0;
            yellow = 1'b0;
            green = 1'b0;
        end
    endcase
end

// Counting logic
always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt <= 10;
    end else begin
        if (pass_request && green) begin
            cnt <= 10;
        end else if (!green && p_green) begin
            cnt <= 60;
        end else if (!yellow && p_yellow) begin
            cnt <= 5;
        end else if (!red && p_red) begin
            cnt <= 10;
        end else begin
            cnt <= cnt - 1;
        end
    end
end

// Assign output clock
assign clock = cnt;

endmodule