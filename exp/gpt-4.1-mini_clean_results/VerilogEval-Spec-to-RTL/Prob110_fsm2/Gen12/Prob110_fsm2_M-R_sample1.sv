module TopModule(
    input  clk,
    input  areset,
    input  j,
    input  k,
    output out
);

    // One-hot state encoding signals
    reg state_off;
    reg state_on;

    wire next_off;
    wire next_on;

    // Next-state combinational logic using assign
    assign next_off = (state_on & k) | (state_off & ~j);
    assign next_on  = (state_off & j) | (state_on & ~k);

    // State flip-flops with asynchronous active-high reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state_off <= 1'b1;  // OFF state active
            state_on  <= 1'b0;
        end else begin
            state_off <= next_off;
            state_on  <= next_on;
        end
    end

    // Moore output combinational from registered state
    assign out = state_on;

endmodule