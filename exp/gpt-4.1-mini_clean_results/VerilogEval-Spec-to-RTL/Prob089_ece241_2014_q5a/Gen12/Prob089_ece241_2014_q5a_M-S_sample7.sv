module TopModule (
    input  clk,
    input  areset,
    input  x,
    output z
);

    // State encoding: 0 = COPY, 1 = INVERT
    reg state, next_state;

    // State register with asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= 1'b0; // COPY state
        else
            state <= next_state;
    end

    // Next state logic
    always @(*) begin
        if (state == 1'b0) begin // COPY
            if (x)
                next_state = 1'b1; // switch to INVERT
            else
                next_state = 1'b0;
        end else begin
            next_state = 1'b1; // stay INVERT
        end
    end

    // Output is input XOR state (Moore output)
    assign z = x ^ state;

endmodule