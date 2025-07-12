module TopModule (
    input  clk,
    input  reset,
    input  j,
    input  k,
    output out
);

    // State encoding
    localparam OFF = 1'b0;
    localparam ON  = 1'b1;

    reg state;
    wire next_state;

    // Combinational state transition logic
    assign next_state = (state == OFF) ? (j ? ON : OFF) :
                        (state == ON) ? (k ? OFF : ON) :
                        OFF; // Default case (shouldn't occur)

    // Sequential state register
    always @(posedge clk) begin
        if (reset)
            state <= OFF;
        else
            state <= next_state;
    end

    // Output logic
    assign out = state;

endmodule