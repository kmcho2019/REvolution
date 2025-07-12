module TopModule(
    input clk,
    input reset,
    input in,
    output reg done
);

// Enum for states
enum logic [2:0] {
    IDLE = 3'b001,
    START = 3'b010,
    DATA = 3'b011,
    STOP = 3'b100,
    DONE = 3'b101
} state, next_state;

// Data bit counter
reg [2:0] counter;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= IDLE;
        counter <= 0;
        done <= 0;
    end else begin
        state <= next_state;
        if (state == DATA) begin
            counter <= counter + 1;
        end else if (state == IDLE || state == STOP) begin
            counter <= 0;
        end

        if (state == DONE) begin
            done <= 1;
        end else begin
            done <= 0;
        end
    end
end

always @(*) begin
    case (state)
        IDLE: begin
            if (~in) begin
                next_state = START;
            end else begin
                next_state = IDLE;
            end
        end
        START: begin
            next_state = DATA;
        end
        DATA: begin
            if (counter == 7) begin
                next_state = STOP;
            end else begin
                next_state = DATA;
            end
        end
        STOP: begin
            if (in) begin
                next_state = DONE;
            end else begin
                next_state = STOP;
            end
        end
        DONE: begin
            next_state = IDLE;
        end
        default: next_state = IDLE;
    endcase
end

endmodule