module traffic_light(
    input logic rst_n,
    input logic clk,
    input logic pass_request,
    output logic [7:0] clock,
    output logic red,
    output logic yellow,
    output logic green
);

// Enum values for different states
enum logic [1:0] {idle, s1_red, s2_yellow, s3_green} state, next_state;

// Internal counter
logic [7:0] cnt;

// Previous values for output signals
logic p_red, p_yellow, p_green;

// Next values for output signals
logic n_red, n_yellow, n_green;

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
        cnt <= 10;
    end else begin
        if (pass_request && green && cnt > 10) begin
            cnt <= 10;
        end else if (green && !p_green) begin
            cnt <= 60;
        end else if (yellow && !p_yellow) begin
            cnt <= 5;
        end else if (red && !p_red) begin
            cnt <= 10;
        end else if (cnt != 0) begin
            cnt <= cnt - 1;
        end
    end
end

// Output signals logic
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
            idle: begin
                red <= 0;
                yellow <= 0;
                green <= 0;
            end
            s1_red: begin
                n_red <= 1;
                n_yellow <= 0;
                n_green <= 0;
            end
            s2_yellow: begin
                n_red <= 0;
                n_yellow <= 1;
                n_green <= 0;
            end
            s3_green: begin
                n_red <= 0;
                n_yellow <= 0;
                n_green <= 1;
            end
            default: begin
                n_red <= 0;
                n_yellow <= 0;
                n_green <= 0;
            end
        endcase
        
        red <= n_red;
        yellow <= n_yellow;
        green <= n_green;
    end
end

// Assign internal counter to output clock
assign clock = cnt;

endmodule