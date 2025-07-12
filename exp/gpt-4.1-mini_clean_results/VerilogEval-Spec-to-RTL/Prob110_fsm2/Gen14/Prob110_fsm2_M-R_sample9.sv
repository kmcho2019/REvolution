module TopModule(
    input clk,
    input areset,
    input j,
    input k,
    output out
);

    // State encoding
    localparam OFF = 1'b0;
    localparam ON  = 1'b1;

    reg state;
    wire next_state;

    // Next state logic (combinational) as assign
    assign next_state = (state == OFF) ? (j ? ON : OFF) :
                        (state == ON)  ? (k ? OFF : ON)  :
                                         OFF;

    // State register with asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= OFF;
        else
            state <= next_state;
    end

    // Output logic (Moore output) as assign
    assign out = (state == ON) ? 1'b1 : 1'b0;

endmodule