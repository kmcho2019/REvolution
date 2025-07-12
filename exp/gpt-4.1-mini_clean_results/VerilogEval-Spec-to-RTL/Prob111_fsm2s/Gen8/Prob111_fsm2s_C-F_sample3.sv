module TopModule(
    input  clk,
    input  reset,
    input  j,
    input  k,
    output out
);

    // State encoding
    localparam OFF = 1'b0,
               ON  = 1'b1;
    reg state;

    // Next state combinational logic
    wire next_state = (state == OFF) ? (j ? ON : OFF)
                                    : (k ? OFF : ON);

    // Sequential logic: synchronous reset and state update
    always @(posedge clk) begin
        if (reset)
            state <= OFF;
        else
            state <= next_state;
    end

    // Moore output logic
    assign out = (state == ON);

endmodule