module traffic_light (
    input wire rst_n,
    input wire clk,
    input wire pass_request,
    output wire [7:0] clock,
    output reg red,
    output reg yellow,
    output reg green
);

// State encoding
localparam [1:0]
    idle      = 2'd0,
    s1_red    = 2'd1,
    s2_yellow = 2'd2,
    s3_green  = 2'd3;

reg [1:0] state, next_state;
reg [7:0] cnt, next_cnt;

// Registers for outputs next values
reg p_red, p_yellow, p_green;
reg next_p_red, next_p_yellow, next_p_green;

// State transition logic and next outputs
always @(*) begin
    next_state = state;
    next_cnt = cnt;
    next_p_red = p_red;
    next_p_yellow = p_yellow;
    next_p_green = p_green;

    case (state)
        idle: begin
            next_state = s1_red;
            next_cnt = 8'd10;
            next_p_red = 0;
            next_p_yellow = 0;
            next_p_green = 0;
        end

        s1_red: begin
            next_p_red = 1;
            next_p_yellow = 0;
            next_p_green = 0;
            if (cnt == 0)
                next_state = s3_green;
            next_cnt = (cnt == 0) ? 8'd60 : cnt - 1;
        end

        s3_green: begin
            next_p_red = 0;
            next_p_yellow = 0;
            next_p_green = 1;
            if (pass_request && cnt > 8'd10)
                next_cnt = 8'd10; // Shorten green time if pedestrian pressed and time > 10
            else if (cnt == 0)
                next_state = s2_yellow;
            else if (!(pass_request && cnt > 8'd10))
                next_cnt = cnt - 1;
        end

        s2_yellow: begin
            next_p_red = 0;
            next_p_yellow = 1;
            next_p_green = 0;
            if (cnt == 0)
                next_state = s1_red;
            next_cnt = (cnt == 0) ? 8'd10 : cnt - 1;
        end

        default: begin
            next_state = idle;
            next_cnt = 8'd10;
            next_p_red = 0;
            next_p_yellow = 0;
            next_p_green = 0;
        end
    endcase
end

// Sequential block for state, counter and output registers
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= idle;
        cnt <= 8'd10;
        red <= 0;
        yellow <= 0;
        green <= 0;
        p_red <= 0;
        p_yellow <= 0;
        p_green <= 0;
    end else begin
        state <= next_state;
        cnt <= next_cnt;
        p_red <= next_p_red;
        p_yellow <= next_p_yellow;
        p_green <= next_p_green;

        // Outputs updated from p_* registers (as per original spec)
        red <= p_red;
        yellow <= p_yellow;
        green <= p_green;
    end
end

assign clock = cnt;

endmodule