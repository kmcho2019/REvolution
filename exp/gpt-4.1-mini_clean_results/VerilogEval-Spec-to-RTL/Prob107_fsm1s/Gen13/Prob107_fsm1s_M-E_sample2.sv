module TopModule (
    input  clk,
    input  reset,
    input  in,
    output out
);

    // One-hot state encoding
    localparam B = 2'b01;
    localparam A = 2'b10;

    reg [1:0] state, next_state;

    // Combinational next state logic
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
            default: next_state = B; // Safe default to reset state
        endcase
    end

    // Sequential state update with synchronous active-high reset
    always @(posedge clk) begin
        if (reset)
            state <= B;
        else
            state <= next_state;
    end

    // Output logic based on state (Moore output)
    assign out = state[0]; // High when in state B

endmodule