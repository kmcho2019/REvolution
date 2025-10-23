module TopModule(
    input clk,
    input reset,
    input data,
    input done_counting,
    input ack,
    output reg shift_ena,
    output reg counting,
    output reg done
);

typedef enum logic [2:0] {Idle, Shift, Counting, Done} state;

reg [2:0] curr_state;
reg [1:0] shift_counter;
reg [3:0] pattern_counter;

always @(posedge clk) begin
    if (reset) begin
        curr_state <= Idle;
        pattern_counter <= 0;
        shift_counter <= 0;
        shift_ena <= 0;
        counting <= 0;
        done <= 0;
    end else begin
        case (curr_state)
            Idle: begin
                if (data == 1'b1 && pattern_counter == 0) begin
                    pattern_counter <= pattern_counter + 1;
                end else if (data == 1'b0 && pattern_counter == 3) begin
                    pattern_counter <= 0;
                end else if (data == 1'b1 && pattern_counter == 1) begin
                    pattern_counter <= pattern_counter + 1;
                end else if (data == 1'b0 && pattern_counter == 1) begin
                    pattern_counter <= 0;
                end else if (data == 1'b0 && pattern_counter == 2) begin
                    pattern_counter <= pattern_counter + 1;
                end else if (data == 1'b1 && pattern_counter == 2) begin
                    pattern_counter <= 0;
                end else if (data == 1'b1 && pattern_counter == 3) begin
                    curr_state <= Shift;
                    pattern_counter <= 0;
                    shift_counter <= 0;
                    shift_ena <= 1;
                end else begin
                    pattern_counter <= 0;
                end
            end
            Shift: begin
                if (shift_counter == 3) begin
                    curr_state <= Counting;
                    shift_ena <= 0;
                    counting <= 1;
                    shift_counter <= 0;
                end else begin
                    shift_counter <= shift_counter + 1;
                end
            end
            Counting: begin
                if (done_counting) begin
                    curr_state <= Done;
                    counting <= 0;
                    done <= 1;
                end
            end
            Done: begin
                if (ack) begin
                    curr_state <= Idle;
                    done <= 0;
                end
            end
        endcase
    end
end

endmodule