module TopModule (
    input clk,
    input reset,
    input data,
    output reg [3:0] count,
    output counting,
    output done,
    input ack
);

    // Pattern Detector FSM
    localparam [1:0]
        PD_IDLE = 2'b00,
        PD_CAPTURE = 2'b01,
        PD_READY = 2'b10;

    // Timer FSM
    localparam [1:0]
        T_IDLE = 2'b00,
        T_COUNT = 2'b01,
        T_DONE = 2'b10;

    reg [1:0] pd_state, t_state;
    reg [3:0] shift_reg;
    reg [3:0] delay_reg;
    reg [3:0] interval_cnt;
    reg [9:0] cycle_cnt;
    reg pattern_matched;
    reg start_timer;
    reg timer_done;

    // Pattern detection logic
    always @(posedge clk) begin
        if (reset) begin
            pd_state <= PD_IDLE;
            shift_reg <= 4'b0;
            pattern_matched <= 1'b0;
            start_timer <= 1'b0;
        end else begin
            shift_reg <= {shift_reg[2:0], data};
            pattern_matched <= (shift_reg == 4'b1101);

            case (pd_state)
                PD_IDLE: begin
                    if (pattern_matched) begin
                        pd_state <= PD_CAPTURE;
                        delay_reg <= 4'b0;
                    end
                end

                PD_CAPTURE: begin
                    delay_reg <= {delay_reg[2:0], data};
                    if (&delay_reg[2:0]) begin  // After 4 bits captured
                        pd_state <= PD_READY;
                        start_timer <= 1'b1;
                    end
                end

                PD_READY: begin
                    start_timer <= 1'b0;
                    if (timer_done && ack) begin
                        pd_state <= PD_IDLE;
                    end
                end
            endcase
        end
    end

    // Timer logic
    always @(posedge clk) begin
        if (reset) begin
            t_state <= T_IDLE;
            interval_cnt <= 4'b0;
            cycle_cnt <= 10'b0;
            count <= 4'b0;
            timer_done <= 1'b0;
        end else begin
            case (t_state)
                T_IDLE: begin
                    if (start_timer) begin
                        t_state <= T_COUNT;
                        interval_cnt <= delay_reg;
                        cycle_cnt <= 10'd999;  // Counts 0-999 (1000 cycles)
                        count <= delay_reg;
                    end
                end

                T_COUNT: begin
                    if (cycle_cnt == 10'b0) begin
                        if (interval_cnt == 4'b0) begin
                            t_state <= T_DONE;
                            timer_done <= 1'b1;
                        end else begin
                            interval_cnt <= interval_cnt - 1;
                            cycle_cnt <= 10'd999;
                            count <= interval_cnt - 1;
                        end
                    end else begin
                        cycle_cnt <= cycle_cnt - 1;
                    end
                end

                T_DONE: begin
                    if (ack) begin
                        t_state <= T_IDLE;
                        timer_done <= 1'b0;
                    end
                end
            endcase
        end
    end

    assign counting = (t_state == T_COUNT);
    assign done = (t_state == T_DONE);

endmodule