module TopModule(
    input clk,
    input reset,
    input j,
    input k,
    output out
);

    // One-hot state encoding: OFF = 2'b01, ON = 2'b10
    reg [1:0] state, next_state;

    // Synchronous state update with active-high reset
    always @(posedge clk) begin
        if (reset)
            state <= 2'b01; // OFF state
        else
            state <= next_state;
    end

    // Next state combinational logic
    always @(*) begin
        case(state)
            2'b01: // OFF
                if (j)
                    next_state = 2'b10; // ON
                else
                    next_state = 2'b01; // OFF
            2'b10: // ON
                if (k)
                    next_state = 2'b01; // OFF
                else
                    next_state = 2'b10; // ON
            default:
                next_state = 2'b01; // Default to OFF for safety
        endcase
    end

    // Output directly derived from ON state flip-flop
    assign out = state[1]; // ON state is high bit

endmodule