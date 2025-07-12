module TopModule(
    input           clk,
    input           reset,
    input   [7:0]   in,
    output          done
);

// Define states for the FSM
enum logic [1:0] {IDLE, COUNTING1, COUNTING2, COUNTING3} state;

always_ff @(posedge clk) begin
    if(reset) begin
        state <= IDLE;
        done <= 0;
    end else begin
        case(state)
            IDLE: begin
                if(in[3]) begin
                    state <= COUNTING1;
                end else begin
                    state <= IDLE;
                end
            end
            COUNTING1: begin
                state <= COUNTING2;
            end
            COUNTING2: begin
                state <= COUNTING3;
            end
            COUNTING3: begin
                state <= IDLE;
                done <= 1;
            end
        endcase
    end
end

assign done = (state == COUNTING3);

endmodule