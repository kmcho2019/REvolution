module TopModule (
    input  clk,
    input  areset,
    input  in,
    output out
);

    // State encoding
    localparam A = 1'b0;
    localparam B = 1'b1;

    reg state;
    reg next_state;

    // Next state logic as combinational if-else
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

    // Sequential logic with asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= B;
        else
            state <= next_state;
    end

    // Moore output combinationally assigned from registered state
    assign out = state;

endmodule