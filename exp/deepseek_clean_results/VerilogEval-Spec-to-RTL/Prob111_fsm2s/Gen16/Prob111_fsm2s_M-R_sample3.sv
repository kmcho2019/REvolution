module TopModule (
    input  clk,
    input  reset,
    input  j,
    input  k,
    output out
);

    // One-hot like state encoding (though only 2 states)
    reg state_off;
    reg state_on;

    // Next state logic (combinational)
    wire next_state_off = (state_off & ~j) | (state_on & k);
    wire next_state_on  = (state_off & j) | (state_on & ~k);

    // State update (sequential)
    always @(posedge clk) begin
        if (reset) begin
            state_off <= 1'b1;
            state_on  <= 1'b0;
        end
        else begin
            state_off <= next_state_off;
            state_on  <= next_state_on;
        end
    end

    // Output logic (combinational)
    assign out = state_on;

endmodule