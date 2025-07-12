module TopModule(
    input  clk,
    input  reset,
    input  data,
    input  done_counting,
    input  ack,
    output reg shift_ena,
    output reg counting,
    output reg done
);

reg [2:0] state;
parameter IDLE = 3'b000, 
             START_SEQ1 = 3'b001, 
             START_SEQ2 = 3'b010, 
             START_SEQ3 = 3'b011, 
             SHIFT = 3'b100, 
             COUNT = 3'b101, 
             DONE_WAIT = 3'b110, 
             DONE = 3'b111;

reg [3:0] shift_count;

always @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        shift_ena <= 0;
        counting <= 0;
        done <= 0;
        shift_count <= 0;
    end
    else begin
        case (state)
            IDLE: begin
                if (data == 1) state <= START_SEQ1;
                else state <= IDLE;
            end
            START_SEQ1: begin
                if (data == 1) state <= START_SEQ1;
                else if (data == 0) state <= START_SEQ2;
                else state <= IDLE;
            end
            START_SEQ2: begin
                if (data == 0) state <= START_SEQ2;
                else if (data == 1) state <= START_SEQ3;
                else state <= IDLE;
            end
            START_SEQ3: begin
                if (data == 1) state <= SHIFT;
                else state <= IDLE;
            end
            SHIFT: begin
                shift_ena <= 1;
                shift_count <= shift_count + 1;
                if (shift_count == 3) begin
                    shift_ena <= 0;
                    state <= COUNT;
                end
            end
            COUNT: begin
                counting <= 1;
                if (done_counting) state <= DONE_WAIT;
            end
            DONE_WAIT: begin
                counting <= 0;
                done <= 1;
                state <= DONE;
            end
            DONE: begin
                if (ack) begin
                    state <= IDLE;
                    done <= 0;
                end
            end
        endcase
    end
end

endmodule