module TopModule(
    input  clk,
    input  areset,
    input  j,
    input  k,
    output out
);

    // State encoding
    localparam OFF = 1'b0;
    localparam ON  = 1'b1;

    reg state;
    reg j_reg, k_reg;
    wire next_state;

    // Register inputs to reduce glitches and improve timing/power
    always @(posedge clk) begin
        j_reg <= j;
        k_reg <= k;
    end

    // Next state logic (combinational)
    assign next_state = (state == OFF) ? (j_reg ? ON : OFF) :
                        (state == ON)  ? (k_reg ? OFF : ON) :
                        OFF; // default fallback

    // Output logic (Moore machine)
    assign out = (state == ON);

    // State register with synchronous active-high reset for better timing and power
    always @(posedge clk) begin
        if (areset)
            state <= OFF;
        else
            state <= next_state;
    end

endmodule