module TopModule(
    input  clk,
    input  areset,
    input  j,
    input  k,
    output reg out
);

    // State encoding (1-bit)
    localparam OFF = 1'b0;
    localparam ON  = 1'b1;

    reg state, next_state;

    // Next state combinational logic - ternary operator for minimal logic depth
    always @(*) begin
        next_state = (state == OFF) ? (j ? ON : OFF)
                     : (k ? OFF : ON);
    end

    // State register with asynchronous active-high reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= OFF;
        else
            state <= next_state;
    end

    // Registered Moore output logic to reduce glitches and improve timing
    always @(posedge clk or posedge areset) begin
        if (areset)
            out <= 1'b0;
        else
            out <= (state == ON);
    end

endmodule