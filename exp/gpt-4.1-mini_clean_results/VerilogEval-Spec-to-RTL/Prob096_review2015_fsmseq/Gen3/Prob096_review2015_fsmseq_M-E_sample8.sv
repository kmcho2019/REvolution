module TopModule(
    input clk,
    input reset,
    input data,
    output reg start_shifting
);

    // One-hot states: 5 bits to represent 5 states
    localparam S0      = 5'b00001; // no match
    localparam S1      = 5'b00010; // matched '1'
    localparam S11     = 5'b00100; // matched '11'
    localparam S110    = 5'b01000; // matched '110'
    localparam S_FOUND = 5'b10000; // sequence found

    reg [4:0] state, next_state;

    // Combinational logic for next state based on current state and input data
    always @(*) begin
        // Default next state is S0
        next_state = S0;

        case(state)
            S0: 
                next_state = data ? S1 : S0;

            S1: 
                next_state = data ? S11 : S0;

            S11:
                next_state = data ? S11 : S110;

            S110:
                next_state = data ? S_FOUND : S0;

            S_FOUND:
                next_state = S_FOUND; // stay here once found
            default:
                next_state = S0;
        endcase
    end

    // Sequential block: update state and latch start_shifting synchronously on clk
    always @(posedge clk) begin
        if (reset) begin
            state <= S0;
            start_shifting <= 1'b0;
        end else begin
            state <= next_state;
            if (next_state == S_FOUND)
                start_shifting <= 1'b1;
            else if (start_shifting)
                start_shifting <= 1'b1; // latch once set
        end
    end

endmodule