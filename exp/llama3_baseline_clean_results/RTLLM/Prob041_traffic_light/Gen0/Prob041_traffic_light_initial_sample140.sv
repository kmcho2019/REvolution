module traffic_light(
    input logic rst_n,
    input logic clk,
    input logic pass_request,
    output logic [7:0] clock,
    output logic red,
    output logic yellow,
    output logic green
);

// Enumerations for states
enum logic [1:0] {idle, s1_red, s2_yellow, s3_green} state, next_state;

// Internal counter
logic [7:0] cnt;

// Previous values for output signals
logic p_red, p_yellow, p_green;

// State transition logic
always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= idle;
        p_red <= 1'b0;
        p_yellow <= 1'b0;
        p_green <= 1'b0;
    end else begin
        case (state)
            idle: state <= s1_red;
            s1_red: if (cnt == 1'b0) state <= s3_green; else state <= s1_red;
            s2_yellow: if (cnt == 1'b0) state <= s1_red; else state <= s2_yellow;
            s3_green: if (cnt == 1'b0) state <= s2_yellow; else state <= s3_green;
            default: state <= idle;
        endcase
        p_red <= red;
        p_yellow <= yellow;
        p_green <= green;
    end
end

// Counting logic
always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt <= 10;
    end else begin
        if (pass_request && green && cnt > 10) begin
            cnt <= 10;
        end else if (!green && p_green) begin
            cnt <= 60;
        end else if (!yellow && p_yellow) begin
            cnt <= 5;
        end else if (!red && p_red) begin
            cnt <= 10;
        end else begin
            cnt <= cnt - 1'b1;
        end
    end
end

// Output signals
always_comb begin
    case (state)
        idle: begin
            red = 1'b0;
            yellow = 1'b0;
            green = 1'b0;
        end
        s1_red: begin
            red = 1'b1;
            yellow = 1'b0;
            green = 1'b0;
        end
        s2_yellow: begin
            red = 1'b0;
            yellow = 1'b1;
            green = 1'b0;
        end
        s3_green: begin
            red = 1'b0;
            yellow = 1'b0;
            green = 1'b1;
        end
        default: begin
            red = 1'b0;
            yellow = 1'b0;
            green = 1'b0;
        end
    endcase
end

// Assign internal counter to output
assign clock = cnt;

endmodule