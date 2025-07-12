module TopModule(
    input  clk,
    input  reset,
    input  j,
    input  k,
    output out
);

    // State encoding using localparam for clarity
    localparam OFF = 1'b0,
               ON  = 1'b1;
    reg state;

    // Next state logic as continuous assignment
    assign out = (state == ON);
    wire next_state = (state == OFF) ? (j ? ON : OFF)
                                    : (k ? OFF : ON);

    // State update with synchronous active-high reset, unconditional update
    always @(posedge clk) begin
        if (reset) 
            state <= OFF;
        else
            state <= next_state;
    end

endmodule