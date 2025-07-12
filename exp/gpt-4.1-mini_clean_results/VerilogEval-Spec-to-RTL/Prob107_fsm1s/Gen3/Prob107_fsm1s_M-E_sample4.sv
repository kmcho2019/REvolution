module TopModule (
    input  clk,
    input  reset,
    input  in,
    output reg out
);

    localparam B = 1'b0;
    localparam A = 1'b1;

    reg state, next_state;

    // Next state combinational logic
    always @(*) begin
        case (state)
            B: next_state = (in == 1'b0) ? A : B;
            A: next_state = (in == 1'b0) ? B : A;
            default: next_state = B; // Default to reset state for safety
        endcase
    end

    // State register with synchronous active-high reset
    always @(posedge clk) begin
        if (reset)
            state <= B;
        else
            state <= next_state;
    end

    // Moore output logic (registered)
    always @(posedge clk) begin
        if (reset)
            out <= 1'b1;  // Output for state B
        else
            out <= (state == B) ? 1'b1 : 1'b0;
    end

endmodule