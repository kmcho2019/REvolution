module TopModule (
    input  clk,
    input  reset,
    input  in,
    output out
);

    // State encoding
    localparam B = 1'b0;
    localparam A = 1'b1;

    reg state;
    reg next_state;

    // Combinational next-state logic
    always @(*) begin
        case(state)
            B: next_state = (in) ? B : A;
            A: next_state = (in) ? A : B;
            default: next_state = B;
        endcase
    end

    // Generate clock enable: update state only if next_state differs
    wire state_en = (state != next_state);

    // Synchronous state update with active-high reset and clock enable
    always @(posedge clk) begin
        if (reset) begin
            state <= B;
        end else if (state_en) begin
            state <= next_state;
        end
    end

    // Moore output assigned continuously based on current state
    assign out = (state == B);

endmodule