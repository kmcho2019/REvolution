module TopModule (
    input  clk,
    input  reset,
    input  data,
    input  done_counting,
    input  ack,
    output reg shift_ena,
    output reg counting,
    output reg done
);

// Define the states
enum logic [2:0] {
    IDLE,
    SHIFT,
    COUNT,
    DONE,
    WAIT_ACK
} state, next_state;

// Current sequence
reg [3:0] curr_seq;

// Counter for shifting
reg [1:0] shift_count;

always @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        curr_seq <= 4'b0;
        shift_count <= 2'b0;
        shift_ena <= 1'b0;
        counting <= 1'b0;
        done <= 1'b0;
    end else begin
        state <= next_state;
        curr_seq <= {curr_seq[2:0], data};
        if (state == SHIFT) begin
            shift_count <= shift_count + 1;
        end else begin
            shift_count <= 2'b0;
        end
        case (state)
            IDLE: begin
                if (curr_seq == 4'b1101) begin
                    next_state <= SHIFT;
                end else begin
                    next_state <= IDLE;
                end
            end
            SHIFT: begin
                shift_ena <= 1'b1;
                if (shift_count == 4) begin
                    next_state <= COUNT;
                end else begin
                    next_state <= SHIFT;
                end
            end
            COUNT: begin
                counting <= 1'b1;
                if (done_counting) begin
                    next_state <= DONE;
                end else begin
                    next_state <= COUNT;
                end
            end
            DONE: begin
                done <= 1'b1;
                next_state <= WAIT_ACK;
            end
            WAIT_ACK: begin
                if (ack) begin
                    next_state <= IDLE;
                end else begin
                    next_state <= WAIT_ACK;
                end
            end
        endcase
        case (next_state)
            IDLE, COUNT, DONE, WAIT_ACK: begin
                shift_ena <= 1'b0;
            end
            SHIFT: begin
                // shift_ena is already set to 1'b1
            end
        endcase
        case (next_state)
            IDLE, SHIFT, DONE, WAIT_ACK: begin
                counting <= 1'b0;
            end
            COUNT: begin
                // counting is already set to 1'b1
            end
        endcase
        case (next_state)
            IDLE, SHIFT, COUNT, WAIT_ACK: begin
                done <= 1'b0;
            end
            DONE: begin
                // done is already set to 1'b1
            end
        endcase
    end
end

endmodule