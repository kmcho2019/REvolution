`timescale 1ns / 1ps
module traffic_light(
    input  wire       rst_n,
    input  wire       clk,
    input  wire       pass_request,
    output reg [7:0]  clock,
    output reg        red,
    output reg        yellow,
    output reg        green
);

    // State encoding
    localparam [1:0]
        idle     = 2'b00,
        s1_red   = 2'b01,
        s3_green = 2'b10,
        s2_yellow= 2'b11;

    // Durations for each state
    localparam [7:0]
        RED_TIME    = 8'd10,
        GREEN_TIME  = 8'd60,
        YELLOW_TIME = 8'd5;

    reg [1:0] state, next_state;
    reg [7:0] cnt, next_cnt;

    // State register
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            state <= idle;
        else
            state <= next_state;
    end

    // Counter register
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            cnt <= 8'd0;
        else
            cnt <= next_cnt;
    end

    // Next state and counter logic
    always @(*) begin
        // Default assignments
        next_state = state;
        next_cnt   = cnt;

        case(state)
            idle: begin
                // Immediately transition to red state with counter load
                next_state = s1_red;
                next_cnt   = RED_TIME - 1;  // count down includes current clock
            end
            s1_red: begin
                if (cnt == 0) begin
                    next_state = s3_green;
                    next_cnt   = GREEN_TIME - 1;
                end else begin
                    next_cnt = cnt - 1;
                end
            end
            s3_green: begin
                if (pass_request && (cnt > 8'd10)) begin
                    // Shorten remaining green time to 10
                    next_cnt = 8'd10 - 1; // -1 because counting down at next cycle
                    next_state = s3_green;
                end else if (cnt == 0) begin
                    next_state = s2_yellow;
                    next_cnt   = YELLOW_TIME - 1;
                end else begin
                    next_cnt = cnt - 1;
                end
            end
            s2_yellow: begin
                if (cnt == 0) begin
                    next_state = s1_red;
                    next_cnt   = RED_TIME - 1;
                end else begin
                    next_cnt = cnt - 1;
                end
            end
            default: begin
                next_state = idle;
                next_cnt = 8'd0;
            end
        endcase
    end

    // Output logic based on current state
    always @(*) begin
        case(state)
            s1_red: begin
                red    = 1'b1;
                yellow = 1'b0;
                green  = 1'b0;
            end
            s3_green: begin
                red    = 1'b0;
                yellow = 1'b0;
                green  = 1'b1;
            end
            s2_yellow: begin
                red    = 1'b0;
                yellow = 1'b1;
                green  = 1'b0;
            end
            default: begin // idle or unknown
                red    = 1'b0;
                yellow = 1'b0;
                green  = 1'b0;
            end
        endcase
    end

    // Assign output clock to current counter + 1 (since counting down from N-1)
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            clock <= 8'd0;
        else
            clock <= cnt + 1'b1;
    end

endmodule