module TopModule (
    input  clk,
    input  reset,
    input  [7:0] in,
    output done
);

// define states
enum logic [1:0] {IDLE, BYTE1, BYTE2, DONE} state, next_state;

// sequential logic
always_ff @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        done <= 0;
    end else begin
        state <= next_state;
        if (state == DONE) begin
            done <= 1;
        end else begin
            done <= 0;
        end
    end
end

// combinational logic
always_comb begin
    next_state = state;
    case (state)
        IDLE: begin
            if (in[3] == 1) begin
                next_state = BYTE1;
            end
        end
        BYTE1: begin
            next_state = BYTE2;
        end
        BYTE2: begin
            next_state = DONE;
        end
        DONE: begin
            if (in[3] == 1) begin
                next_state = BYTE1;
            end else begin
                next_state = IDLE;
            end
        end
    endcase
end

endmodule