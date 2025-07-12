module TopModule(
    input           clk,
    input           reset,
    input   [7:0]   in,
    output          done
);

enum logic [1:0] {IDLE, BYTE1, BYTE2, BYTE3} state, next_state;

always_comb begin
    next_state = state;
    case(state)
        IDLE: begin
            if(in[3]) next_state = BYTE1;
            else next_state = IDLE;
        end
        BYTE1: begin
            next_state = BYTE2;
        end
        BYTE2: begin
            next_state = BYTE3;
        end
        BYTE3: begin
            next_state = IDLE;
        end
    endcase
end

always_ff @(posedge clk) begin
    if(reset) begin
        state <= IDLE;
        done <= 0;
    end
    else begin
        state <= next_state;
        if(next_state == IDLE && state == BYTE3) begin
            done <= 1;
        end
        else begin
            done <= 0;
        end
    end
end

endmodule