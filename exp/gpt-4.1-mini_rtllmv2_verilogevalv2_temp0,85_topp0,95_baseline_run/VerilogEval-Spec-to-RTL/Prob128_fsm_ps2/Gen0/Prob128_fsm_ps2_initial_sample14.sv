module TopModule (
    input        clk,
    input        reset,
    input  [7:0] in,
    output reg   done
);

    typedef enum reg [1:0] {IDLE, BYTE2, BYTE3} state_t;
    state_t state, next_state;

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            done <= 1'b0;
        end else begin
            state <= next_state;
            if (state == BYTE3)
                done <= 1'b1;
            else
                done <= 1'b0;
        end
    end

    always @(*) begin
        case (state)
            IDLE:   next_state = (in[3] == 1'b1) ? BYTE2 : IDLE;
            BYTE2:  next_state = BYTE3;
            BYTE3:  next_state = IDLE;
            default: next_state = IDLE;
        endcase
    end

endmodule