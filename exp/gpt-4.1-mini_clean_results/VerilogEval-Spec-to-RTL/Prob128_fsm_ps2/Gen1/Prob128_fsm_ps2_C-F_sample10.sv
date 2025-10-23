module TopModule (
    input        clk,
    input        reset,
    input  [7:0] in,
    output reg   done
);

    typedef enum reg [1:0] {
        IDLE  = 2'd0,
        BYTE2 = 2'd1,
        BYTE3 = 2'd2
    } state_t;

    state_t state, next_state;

    // State register and done signal registered separately to improve timing clarity
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            done  <= 1'b0;
        end else begin
            state <= next_state;
            // done asserted only in the cycle after third byte received (state BYTE3)
            done <= (state == BYTE3);
        end
    end

    // Next state combinational logic
    always @(*) begin
        case(state)
            IDLE:   next_state = (in[3]) ? BYTE2 : IDLE;
            BYTE2:  next_state = BYTE3;
            BYTE3:  next_state = IDLE;
            default: next_state = IDLE;
        endcase
    end

endmodule