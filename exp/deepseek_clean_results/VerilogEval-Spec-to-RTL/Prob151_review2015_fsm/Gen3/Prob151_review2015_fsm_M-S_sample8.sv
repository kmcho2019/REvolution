module TopModule (
    input clk,
    input reset,
    input data,
    input done_counting,
    input ack,
    output reg shift_ena,
    output reg counting,
    output reg done
);

    // States
    localparam IDLE  = 2'b00;
    localparam SHIFT = 2'b01;
    localparam COUNT = 2'b10;
    localparam DONE  = 2'b11;

    reg [1:0] state;
    reg [1:0] shift_cnt;
    reg [3:0] pattern_detect;

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            shift_cnt <= 0;
            pattern_detect <= 0;
            {shift_ena, counting, done} <= 3'b000;
        end else begin
            case (state)
                IDLE: begin
                    pattern_detect <= {pattern_detect[2:0], data};
                    if (pattern_detect == 4'b1101) begin
                        state <= SHIFT;
                        shift_cnt <= 0;
                    end
                end

                SHIFT: begin
                    shift_cnt <= shift_cnt + 1;
                    if (shift_cnt == 2'b11)
                        state <= COUNT;
                end

                COUNT: begin
                    if (done_counting)
                        state <= DONE;
                end

                DONE: begin
                    if (ack)
                        state <= IDLE;
                end
            endcase
        end
    end

    // Output assignments based on current state
    always @(*) begin
        shift_ena = (state == SHIFT);
        counting = (state == COUNT);
        done = (state == DONE);
    end

endmodule