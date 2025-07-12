module TopModule (
    input  clk,
    input  reset,
    input  j,
    input  k,
    output out
);

    // State register (also serves as output)
    reg state;

    // Next state logic (combinational)
    wire next_state = (state) ? ~k : j;

    // State update (sequential)
    always @(posedge clk) begin
        if (reset)
            state <= 1'b0;
        else
            state <= next_state;
    end

    // Output is directly the state (Moore machine)
    assign out = state;

endmodule