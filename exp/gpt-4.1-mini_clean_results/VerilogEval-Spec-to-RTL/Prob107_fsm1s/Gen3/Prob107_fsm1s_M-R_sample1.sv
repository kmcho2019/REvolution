module TopModule(
    input clk,
    input reset,
    input in,
    output out
);

    // State encoding using parameters
    parameter B = 1'b0, A = 1'b1;
    reg state, next_state;

    // State transition logic with synchronous reset
    always @(posedge clk) begin
        if (reset)
            state <= B;
        else
            state <= next_state;
    end

    // Next state combinational logic
    always @(*) begin
        if (state == B) begin
            if (in == 1'b0)
                next_state = A;
            else
                next_state = B;
        end else begin // state == A
            if (in == 1'b0)
                next_state = B;
            else
                next_state = A;
        end
    end

    // Output as combinational assigned from current state
    assign out = (state == B) ? 1'b1 : 1'b0;

endmodule