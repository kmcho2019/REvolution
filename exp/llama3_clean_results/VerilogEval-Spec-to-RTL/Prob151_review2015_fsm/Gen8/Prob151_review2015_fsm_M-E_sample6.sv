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

reg [2:0] state;
parameter IDLE = 3'b000;
parameter SHIFT = 3'b001;
parameter COUNT = 3'b010;
parameter DONE = 3'b011;

reg [3:0] counter;
reg [3:0] pattern;
reg [3:0] duration;

initial begin
    state = IDLE;
    counter = 0;
    pattern = 0;
    duration = 0;
    shift_ena = 0;
    counting = 0;
    done = 0;
end

always @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        counter <= 0;
        pattern <= 0;
        duration <= 0;
        shift_ena <= 0;
        counting <= 0;
        done <= 0;
    end
    else begin
        case (state)
            IDLE: begin
                pattern <= {pattern[2:0], data};
                if (pattern == 4'b1101) begin
                    state <= SHIFT;
                    counter <= 0;
                    shift_ena <= 1;
                end
                counting <= 0;
                done <= 0;
            end
            SHIFT: begin
                duration <= {duration[2:0], data};
                counter <= counter + 1;
                if (counter == 4) begin
                    state <= COUNT;
                    counter <= 0;
                    shift_ena <= 0;
                    counting <= 1;
                end
                done <= 0;
            end
            COUNT: begin
                if (done_counting) begin
                    state <= DONE;
                    counter <= 0;
                    counting <= 0;
                    done <= 1;
                end
                shift_ena <= 0;
            end
            DONE: begin
                if (ack) begin
                    state <= IDLE;
                    counter <= 0;
                    pattern <= 0;
                    duration <= 0;
                    shift_ena <= 0;
                    counting <= 0;
                    done <= 0;
                end
            end
        endcase
    end
end

endmodule