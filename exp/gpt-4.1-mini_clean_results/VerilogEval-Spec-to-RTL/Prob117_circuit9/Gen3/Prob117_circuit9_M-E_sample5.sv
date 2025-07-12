module TopModule (
    input clk,
    input a,
    output reg [2:0] q
);
    typedef enum logic {HOLD, COUNT} state_t;
    state_t state, next_state;

    // State register
    always @(posedge clk) begin
        state <= next_state;
    end

    // Next state logic
    always @(*) begin
        case (state)
            HOLD: next_state = (a == 1'b0) ? COUNT : HOLD;
            COUNT: next_state = (a == 1'b1) ? HOLD : COUNT;
            default: next_state = HOLD;
        endcase
    end

    // Output and counter update
    always @(posedge clk) begin
        case (state)
            HOLD: q <= 3'd4;
            COUNT: begin
                if (q == 3'd6)
                    q <= 3'd0;
                else
                    q <= q + 1'b1;
            end
            default: q <= 3'bxxx;
        endcase
    end
endmodule