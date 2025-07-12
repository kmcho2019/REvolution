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
enum logic [1:0] {
    idle = 2'b00,
    s1_red = 2'b01,
    s2_yellow = 2'b10,
    s3_green = 2'b11
} state, next_state;

// Define the internal counter and output signals
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
        case (state)
            idle: begin
                state <= s1_red;
            end
            s1_red: begin
                if (cnt == 1'b0) begin
                    state <= s3_green;
                end
            end
            s2_yellow: begin
                if (cnt == 1'b0) begin
                    state <= s1_red;
                end
            end
            s3_green: begin
                if (cnt == 1'b0) begin
                    state <= s2_yellow;
                end else if (pass_request && p_green) begin
                    cnt <= 10;
                end
            end
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
        case (state)
            s1_red: begin
                if (cnt == 1'b0) begin
                    cnt <= 10;
                end else begin
                    cnt <= cnt - 1;
                end
            end
            s2_yellow: begin
                if (cnt == 1'b0) begin
                    cnt <= 5;
                end else begin
                    cnt <= cnt - 1;
                end
            end
            s3_green: begin
                if (cnt == 1'b0) begin
                    cnt <= 60;
                end else if (pass_request && p_green && cnt > 10) begin
                    cnt <= 10;
                end else begin
                    cnt <= cnt - 1;
                end
            end
            default: cnt <= cnt;
        endcase
    end
end

// Output signals
always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        red <= 1'b0;
        yellow <= 1'b0;
        green <= 1'b0;
    end else begin
        case (state)
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
                red <= p_red;
                yellow <= p_yellow;
                green <= p_green;
            end
        endcase
    end
end

// Assign the internal counter to the output clock
assign clock = cnt;

endmodule