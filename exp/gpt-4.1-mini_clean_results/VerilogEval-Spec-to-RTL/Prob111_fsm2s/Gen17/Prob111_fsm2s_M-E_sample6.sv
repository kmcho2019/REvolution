module TopModule(
    input  clk,
    input  reset,
    input  j,
    input  k,
    output out
);

    reg [1:0] state;

    // Synchronous state update with reset
    always @(posedge clk) begin
        if (reset)
            state <= 2'b00; // OFF
        else begin
            if (state == 2'b00)       // OFF state
                state <= {state[0], j};
            else if (state == 2'b11)  // ON state
                state <= {state[0], ~k};
            else
                state <= 2'b00;       // Defensive fallback to OFF
        end
    end

    // Output is high only when both bits are 1 (ON)
    assign out = (state == 2'b11);

endmodule