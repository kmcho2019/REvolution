module TopModule (
    input  wire clk,
    input  wire areset,
    input  wire x,
    output wire z
);

    reg x_reg;
    reg state;
    reg next_state;

    // Sample input x asynchronously with reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            x_reg <= 1'b0;
        else
            x_reg <= x;
    end

    // Update FSM state asynchronously with reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= 1'b0;
        else
            state <= next_state;
    end

    // Next state logic: if in COPY state and x_reg is 1, go to INVERT, else hold
    always @(*) begin
        if (state == 1'b0) begin
            if (x_reg == 1'b1)
                next_state = 1'b1;
            else
                next_state = 1'b0;
        end else begin
            next_state = 1'b1;
        end
    end

    // Moore output as XOR of stored input and FSM state
    assign z = x_reg ^ state;

endmodule