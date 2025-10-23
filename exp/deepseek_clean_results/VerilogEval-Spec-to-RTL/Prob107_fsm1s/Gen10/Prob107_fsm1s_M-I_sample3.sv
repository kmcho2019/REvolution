module TopModule (
    input clk,
    input reset,
    input in,
    output out
);

    typedef enum {STATE_B, STATE_A} state_t;
    state_t state;

    always @(posedge clk) begin
        if (reset) begin
            state <= STATE_B;
        end else begin
            state <= (state == STATE_B) ? (in ? STATE_B : STATE_A)
                                        : (in ? STATE_A : STATE_B);
        end
    end

    assign out = (state == STATE_B);

endmodule