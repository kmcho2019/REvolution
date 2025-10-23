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

    // Combinational next state logic using case and if-else for clarity
    always @(*) begin
        case (state)
            B: begin
                if (in == 1'b0)
                    next_state = A;
                else
                    next_state = B;
            end
            A: begin
                if (in == 1'b0)
                    next_state = B;
                else
                    next_state = A;
            end
            default: next_state = B; // Defensive default
        endcase
    end

    // Synchronous reset and state update
    always @(posedge clk) begin
        if (reset)
            state <= B;
        else
            state <= next_state;
    end

    // Moore output directly from current state (no output register)
    assign out = (state == B) ? 1'b1 : 1'b0;

endmodule