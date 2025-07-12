module traffic_light(
    input  logic rst_n, clk, pass_request,
    output logic [7:0] clock,
    output logic red, yellow, green
);

// Define the states
enum logic [1:0] {
    idle,
    s1_red,
    s2_yellow,
    s3_green
} state, next_state;

// Define the registers and wires
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
                p_red <= 1'b1;
                p_yellow <= 1'b0;
                p_green <= 1'b0;
            end
            s1_red: begin
                if (cnt == 8'd0) begin
                    state <= s3_green;
                    p_red <= 1'b0;
                    p_yellow <= 1'b0;
                    p_green <= 1'b1;
                end else begin
                    state <= s1_red;
                    p_red <= 1'b1;
                    p_yellow <= 1'b0;
                    p_green <= 1'b0;
                end
            end
            s2_yellow: begin
                if (cnt == 8'd0) begin
                    state <= s1_red;
                    p_red <= 1'b1;
                    p_yellow <= 1'b0;
                    p_green <= 1'b0;
                end else begin
                    state <= s2_yellow;
                    p_red <= 1'b0;
                    p_yellow <= 1'b1;
                    p_green <= 1'b0;
                end
            end
            s3_green: begin
                if (cnt == 8'd0) begin
                    state <= s2_yellow;
                    p_red <= 1'b0;
                    p_yellow <= 1'b1;
                    p_green <= 1'b0;
                end else begin
                    state <= s3_green;
                    p_red <= 1'b0;
                    p_yellow <= 1'b0;
                    p_green <= 1'b1;
                end
            end
            default: begin
                state <= idle;
                p_red <= 1'b0;
                p_yellow <= 1'b0;
                p_green <= 1'b0;
            end
        endcase
    end
end

// Counting logic
always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt <= 8'd10;
    end else begin
        if (pass_request && p_green) begin
            cnt <= 8'd10;
        end else if (!p_green && p_green == 1'b1) begin
            cnt <= 8'd60;
        end else if (!p_yellow && p_yellow == 1'b1) begin
            cnt <= 8'd5;
        end else if (!p_red && p_red == 1'b1) begin
            cnt <= 8'd10;
        end else if (cnt != 8'd0) begin
            cnt <= cnt - 1'b1;
        end
    end
end

// Assign the count value to the output clock
assign clock = cnt;

// Output signals
always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        red <= 1'b0;
        yellow <= 1'b0;
        green <= 1'b0;
    end else begin
        red <= p_red;
        yellow <= p_yellow;
        green <= p_green;
    end
end

endmodule