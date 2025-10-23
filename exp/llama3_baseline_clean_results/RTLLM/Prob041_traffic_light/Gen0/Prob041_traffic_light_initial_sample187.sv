module traffic_light(
    input logic rst_n,
    input logic clk,
    input logic pass_request,
    output logic [7:0] clock,
    output logic red,
    output logic yellow,
    output logic green
);

// Enumerations for different states
enum logic [1:0] {idle, s1_red, s2_yellow, s3_green} state, next_state;

// Internal counter
logic [7:0] cnt;

// Previous values of the output signals
logic p_red, p_yellow, p_green;

// State transition logic
always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= idle;
        p_red <= 1'b0;
        p_yellow <= 1'b0;
        p_green <= 1'b0;
    end
    else begin
        case (state)
            idle: state <= s1_red;
            s1_red: if (cnt == 8'd0) state <= s3_green;
            s2_yellow: if (cnt == 8'd0) state <= s1_red;
            s3_green: if (cnt == 8'd0) state <= s2_yellow;
            default: state <= state;
        endcase
        p_red <= red;
        p_yellow <= yellow;
        p_green <= green;
    end
end

// Counting logic of the internal counter
always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt <= 8'd10;
    end
    else begin
        case (state)
            idle: cnt <= 8'd10;
            s1_red: if (cnt > 8'd0) cnt <= cnt - 8'd1;
            s2_yellow: if (cnt > 8'd0) cnt <= cnt - 8'd1;
            s3_green: if (cnt > 8'd0) cnt <= cnt - 8'd1;
            default: cnt <= cnt;
        endcase
        if (pass_request && p_green) begin
            if (cnt > 8'd10) cnt <= 8'd10;
        end
        else if (!p_green && p_green != 1'b0) begin
            if (cnt != 8'd60) cnt <= 8'd60;
        end
        else if (!p_yellow && p_yellow != 1'b0) begin
            if (cnt != 8'd5) cnt <= 8'd5;
        end
        else if (!p_red && p_red != 1'b0) begin
            if (cnt != 8'd10) cnt <= 8'd10;
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

// Assign the value of the internal counter to the output clock
assign clock = cnt;

endmodule