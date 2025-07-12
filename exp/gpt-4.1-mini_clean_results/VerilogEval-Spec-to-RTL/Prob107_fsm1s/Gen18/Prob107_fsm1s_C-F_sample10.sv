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
            B: next_state = (in == 1'b0) ? A : B;
            A: next_state = (in == 1'b0) ? B : A;
            default: next_state = B;
        endcase
    end

    // Synchronous state update with active-high reset
    // Conditional update minimizes toggling and reduces power
    always @(posedge clk) begin
        if (reset) begin
            state <= B;
        end else if (next_state != state) begin
            state <= next_state;
        end
    end

    // Moore output assigned based on current state
    assign out = (state == B) ? 1'b1 : 1'b0;

endmodule