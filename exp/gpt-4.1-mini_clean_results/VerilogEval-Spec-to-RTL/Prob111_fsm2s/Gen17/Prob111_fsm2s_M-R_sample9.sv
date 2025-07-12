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

    // Next state combinational logic using continuous assignment
    wire next_state;
    assign next_state = (state == OFF) ? (j ? ON : OFF)
                                     : (k ? OFF : ON);

    // State update (sequential)
    always @(posedge clk) begin
        if (reset)
            state <= OFF;
        else
            state <= next_state;
    end

    // Moore output
    assign out = (state == ON);

endmodule