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
    wire next_state;
    wire state_en;

    // Next state logic (combinational)
    assign next_state = (state == OFF) ? (j ? ON : OFF) :
                        (state == ON)  ? (k ? OFF : ON) :
                        OFF; // default fallback

    // Output logic (Moore machine)
    assign out = (state == ON);

    // Enable updating state only when next_state differs (power optimization)
    assign state_en = (next_state != state);

    // State register with asynchronous active-high reset and clock enable
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= OFF;
        else if (state_en)
            state <= next_state;
        // else hold state to prevent unnecessary toggling
    end

endmodule