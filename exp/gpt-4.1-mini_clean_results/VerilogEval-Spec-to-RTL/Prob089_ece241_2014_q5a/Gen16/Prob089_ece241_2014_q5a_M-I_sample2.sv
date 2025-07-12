module TopModule (
    input  wire clk,
    input  wire areset,
    input  wire x,
    output wire z
);

    reg state, next_state;

    // Synchronous reset and state update
    always @(posedge clk) begin
        if (areset)
            state <= 1'b0;
        else
            state <= next_state;
    end

    // Next state logic: stay in COPY (0) if x=0, move to INVERT (1) if x=1, else stay in INVERT (1)
    always @(*) begin
        if (state == 1'b0) begin
            if (x == 1'b1)
                next_state = 1'b1;
            else
                next_state = 1'b0;
        end else begin
            next_state = 1'b1;
        end
    end

    // Moore output: XOR of input x and FSM state
    assign z = x ^ state;

endmodule