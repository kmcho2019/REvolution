module traffic_light (
    input logic rst_n,
    input logic clk,
    input logic pass_request,
    output logic [7:0] clock,
    output logic red,
    output logic yellow,
    output logic green
);

// Define states
enum logic [1:0] {
    idle,
    s1_red,
    s2_yellow,
    s3_green
} state, next_state;

// Define registers
logic [7:0] cnt;
logic p_red, p_yellow, p_green;

// State transition logic
always_comb begin
    case (state)
        idle: next_state = s1_red;
        s1_red: next_state = (cnt == 0) ? s3_green : s1_red;
        s2_yellow: next_state = (cnt == 0) ? s1_red : s2_yellow;
        s3_green: next_state = (cnt == 0) ? s2_yellow : s3_green;
        default: next_state = idle;
    endcase
end

// Update state
always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= idle;
    end else begin
        state <= next_state;
    end
end

// Counting logic
always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt <= 10;
    end else begin
        case (state)
            s1_red: if (p_red) cnt <= 10; else cnt <= cnt - 1;
            s2_yellow: if (p_yellow) cnt <= 5; else cnt <= cnt - 1;
            s3_green: if (p_green && pass_request && cnt > 10) cnt <= 10; 
                       else if (p_green) cnt <= 60; 
                       else cnt <= cnt - 1;
            default: cnt <= cnt - 1;
        endcase
    end
end

// Update output signals
always_ff @(posedge clk or negedge rst_n) begin
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

// Assign output clock
assign clock = cnt;

endmodule