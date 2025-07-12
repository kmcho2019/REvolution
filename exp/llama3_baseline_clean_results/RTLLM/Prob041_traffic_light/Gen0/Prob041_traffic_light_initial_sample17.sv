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
typedef enum logic [1:0] {
    idle,
    s1_red,
    s2_yellow,
    s3_green
} states;

// Registers and wires
states state, next_state;
logic [7:0] cnt, next_cnt;
logic p_red, p_yellow, p_green;

// State transition logic
always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= idle;
        cnt <= 8'd10;
        p_red <= 1'b0;
        p_yellow <= 1'b0;
        p_green <= 1'b0;
    end else begin
        state <= next_state;
        cnt <= next_cnt;
        p_red <= red;
        p_yellow <= yellow;
        p_green <= green;
    end
end

// Counting logic
always_comb begin
    next_state = state;
    next_cnt = cnt;
    case (state)
        idle: begin
            next_state = s1_red;
        end
        s1_red: begin
            if (cnt == 8'd0) begin
                next_state = s3_green;
                next_cnt = 8'd60;
            end else begin
                next_cnt = cnt - 8'd1;
            end
        end
        s2_yellow: begin
            if (cnt == 8'd0) begin
                next_state = s1_red;
                next_cnt = 8'd10;
            end else begin
                next_cnt = cnt - 8'd1;
            end
        end
        s3_green: begin
            if (cnt == 8'd0) begin
                next_state = s2_yellow;
                next_cnt = 8'd5;
            end else if (pass_request && cnt > 8'd10) begin
                next_cnt = 8'd10;
            end else begin
                next_cnt = cnt - 8'd1;
            end
        end
    endcase
end

// Output logic
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
    endcase
end

// Assign statement for output clock
assign clock = cnt;

endmodule