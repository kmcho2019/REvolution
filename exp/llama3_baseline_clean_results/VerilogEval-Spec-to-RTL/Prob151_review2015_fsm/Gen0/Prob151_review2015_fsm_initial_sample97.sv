module TopModule(
    input  clk,
    input  reset,
    input  data,
    input  done_counting,
    input  ack,
    output shift_ena,
    output counting,
    output done
);

reg [3:0] state; // 4 states: IDLE, SHIFT, COUNTING, DONE, ACK
reg [2:0] counter; // counter for SHIFT state
reg [3:0] pattern; // register to store the pattern
reg [3:0] prev_pattern; // register to store the previous pattern

// IDLE, SHIFT, COUNTING, DONE, ACK states
parameter IDLE = 4'd0;
parameter SHIFT = 4'd1;
parameter COUNTING = 4'd2;
parameter DONE = 4'd3;
parameter ACK = 4'd4;

// Set initial state
initial begin
    state = IDLE;
    counter = 3'b0;
    pattern = 4'b0;
    prev_pattern = 4'b0;
end

always @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        counter <= 3'b0;
        pattern <= 4'b0;
        prev_pattern <= 4'b0;
    end else begin
        case(state)
            IDLE: begin
                // Shift in the data bit
                prev_pattern <= pattern;
                pattern <= {pattern[2:0], data};
                if (pattern == 4'b1101) begin
                    state <= SHIFT;
                    counter <= 3'b0;
                end else begin
                    state <= IDLE;
                end
            end
            SHIFT: begin
                shift_ena <= 1'b1;
                counter <= counter + 1'b1;
                if (counter == 3'b100) begin
                    state <= COUNTING;
                    shift_ena <= 1'b0;
                end else begin
                    state <= SHIFT;
                end
            end
            COUNTING: begin
                counting <= 1'b1;
                if (done_counting) begin
                    counting <= 1'b0;
                    state <= DONE;
                end else begin
                    state <= COUNTING;
                end
            end
            DONE: begin
                done <= 1'b1;
                if (ack) begin
                    done <= 1'b0;
                    state <= ACK;
                end else begin
                    state <= DONE;
                end
            end
            ACK: begin
                if (ack) begin
                    state <= IDLE;
                end else begin
                    state <= ACK;
                end
            end
            default: begin
                state <= IDLE;
            end
        endcase
    end
end

// Continuous assignments
assign shift_ena = (state == SHIFT) ? 1'b1 : 1'b0;
assign counting = (state == COUNTING) ? 1'b1 : 1'b0;
assign done = (state == DONE) ? 1'b1 : 1'b0;

endmodule