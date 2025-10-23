module traffic_light(
    input logic rst_n,
    input logic clk,
    input logic pass_request,
    output logic [7:0] clock,
    output logic red,
    output logic yellow,
    output logic green
);

// Define the states of the traffic light controller
enum logic [1:0] {idle, s1_red, s2_yellow, s3_green} state, next_state;

// Define the internal counter
logic [7:0] cnt;

// Define the previous values of the output signals
logic p_red, p_yellow, p_green;

// State transition logic
always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= idle;
    end else begin
        state <= next_state;
    end
end

always_comb begin
    case (state)
        idle: next_state = s1_red;
        s1_red: next_state = (cnt == 0) ? s3_green : s1_red;
        s2_yellow: next_state = (cnt == 0) ? s1_red : s2_yellow;
        s3_green: next_state = (cnt == 0) ? s2_yellow : s3_green;
        default: next_state = idle;
    endcase
end

// Counting logic
always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt <= 8'd10;
    end else if (pass_request && green) begin
        cnt <= 8'd10;
    end else if (!green && p_green) begin
        cnt <= 8'd60;
    end else if (!yellow && p_yellow) begin
        cnt <= 8'd5;
    end else if (!red && p_red) begin
        cnt <= 8'd10;
    end else if (cnt != 0) begin
        cnt <= cnt - 8'd1;
    end
end

// Output signal handling
always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        p_red <= 1'b0;
        p_yellow <= 1'b0;
        p_green <= 1'b0;
        red <= 1'b0;
        yellow <= 1'b0;
        green <= 1'b0;
    end else begin
        p_red <= red;
        p_yellow <= yellow;
        p_green <= green;
        case (state)
            idle: begin
                red <= 1'b0;
                yellow <= 1'b0;
                green <= 1'b0;
            end
            s1_red: begin
                red <= 1'b1;
                yellow <= 1'b0;
                green <= 1'b0;
            end
            s2_yellow: begin
                red <= 1'b0;
                yellow <= 1'b1;
                green <= 1'b0;
            end
            s3_green: begin
                red <= 1'b0;
                yellow <= 1'b0;
                green <= 1'b1;
            end
            default: begin
                red <= 1'b0;
                yellow <= 1'b0;
                green <= 1'b0;
            end
        endcase
    end
end

// Assign the value of the internal counter to the output clock
assign clock = cnt;

endmodule