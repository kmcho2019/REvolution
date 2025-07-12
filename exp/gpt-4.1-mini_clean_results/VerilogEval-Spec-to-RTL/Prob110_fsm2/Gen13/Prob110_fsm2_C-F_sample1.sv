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
    reg next_state;
    reg state_en;

    // Next state logic (combinational)
    always @(*) begin
        case(state)
            OFF: next_state = (j) ? ON : OFF;
            ON : next_state = (k) ? OFF : ON;
            default: next_state = OFF; // Safe default
        endcase
    end

    // Sequential block: state register with async reset and clock enable
    // Clock enable is generated inside synchronous logic to avoid glitches
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= OFF;
            state_en <= 1'b0;
        end else begin
            state_en <= (next_state != state);
            if (state_en)
                state <= next_state;
            // else hold state (no toggle, reduces power)
        end
    end

    // Output logic: Moore output directly from state bit (minimal combinational logic)
    assign out = state;

endmodule