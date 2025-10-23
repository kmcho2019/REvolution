module TopModule (
    input clk,
    input reset,
    input data,
    output [3:0] count,
    output counting,
    output done,
    input ack
);

    reg [3:0] delay;
    reg [3:0] counter;
    reg [9:0] timer;
    reg [3:0] count_out;
    reg state_idle;
    reg state_delay;
    reg state_counting;
    reg state_done;

    initial begin
        state_idle = 1'b1;
        state_delay = 1'b0;
        state_counting = 1'b0;
        state_done = 1'b0;
    end

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state_idle = 1'b1;
            state_delay = 1'b0;
            state_counting = 1'b0;
            state_done = 1'b0;
            count_out = 4'b0;
            timer = 10'b0;
            delay = 4'b0;
            done = 1'b0;
            counting = 1'b0;
        end else begin
            case ({state_idle, state_delay, state_counting, state_done})
                4'b1000: begin // idle state
                    if (data) begin // first bit of pattern
                        state_idle = 1'b0;
                        state_delay = 1'b1;
                        state_counting = 1'b0;
                        state_done = 1'b0;
                        delay[3] = 1'b1;
                    end
                end
                4'b0100: begin // delay state
                    case (delay[2:0])
                        3'b001: begin // second bit of pattern
                            if (!data) begin // second bit of pattern
                                delay[2] = 1'b0;
                            end else begin
                                delay[2] = 1'b1;
                            end
                        end
                        3'b010: begin // third bit of pattern
                            if (data) begin // third bit of pattern
                                delay[1] = 1'b1;
                            end else begin
                                delay[1] = 1'b0;
                            end
                        end
                        3'b011: begin // fourth bit of pattern
                            if (!data) begin // fourth bit of pattern
                                delay[0] = 1'b0;
                            end else begin
                                delay[0] = 1'b1;
                            end
                            state_idle = 1'b0;
                            state_delay = 1'b0;
                            state_counting = 1'b1;
                            state_done = 1'b0;
                            timer = (delay + 1) * 1000 - 1;
                            count_out = delay;
                            counting = 1'b1;
                        end
                    endcase
                end
                4'b0010: begin // counting state
                    if (timer == 0) begin
                        if (count_out == 0) begin
                            state_idle = 1'b0;
                            state_delay = 1'b0;
                            state_counting = 1'b0;
                            state_done = 1'b1;
                            done = 1'b1;
                            counting = 1'b0;
                        end else begin
                            timer = 1000 - 1;
                            count_out = count_out - 1;
                        end
                    end else begin
                        timer = timer - 1;
                    end
                    count = count_out;
                end
                4'b0001: begin // done state
                    if (ack) begin
                        state_idle = 1'b1;
                        state_delay = 1'b0;
                        state_counting = 1'b0;
                        state_done = 1'b0;
                        done = 1'b0;
                        count_out = 4'b0;
                        timer = 10'b0;
                        delay = 4'b0;
                    end
                end
            endcase
        end
    end
endmodule