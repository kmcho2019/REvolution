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

// Define the internal counter and the previous values of the output signals
logic [7:0] cnt;
logic p_red, p_yellow, p_green;

// Always block for state transition logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= idle;
    end else begin
        state <= next_state;
    end
end

always @(*) begin
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
            end else if (pass_request && p_green) begin
                next_state <= s3_green;
            end else begin
                next_state <= s3_green;
            end
        end
        default: begin
            next_state <= idle;
        end
    endcase
end

// Always block for counting logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt <= 10;
        p_red <= 1'b0;
        p_yellow <= 1'b0;
        p_green <= 1'b0;
    end else begin
        if (pass_request && p_green && cnt > 10) begin
            cnt <= 10;
        end else if (!p_green && state == s3_green) begin
            cnt <= 60;
        end else if (!p_yellow && state == s2_yellow) begin
            cnt <= 5;
        end else if (!p_red && state == s1_red) begin
            cnt <= 10;
        end else begin
            if (cnt > 0) begin
                cnt <= cnt - 1;
            end else begin
                cnt <= 0;
            end
        end
        p_red <= red;
        p_yellow <= yellow;
        p_green <= green;
    end
end

// Always block for output signals
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        red <= 1'b0;
        yellow <= 1'b0;
        green <= 1'b0;
    end else begin
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

// Assign statement for output clock
assign clock = cnt;

endmodule