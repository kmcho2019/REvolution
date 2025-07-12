module TopModule (
    input clk,
    input reset,
    input j,
    input k,
    output out
);

    // Define states
    parameter OFF = 1'b0;
    parameter ON  = 1'b1;

    // State register
    reg state;

    // State transition and output
    always @(posedge clk) begin
        if (reset)
            state <= OFF;
        else
            state <= (state == OFF) ? (j ? ON : OFF) :
                     (k ? OFF : ON); // state must be ON here
    end

    // Output is directly the state (Moore machine)
    assign out = state;

endmodule