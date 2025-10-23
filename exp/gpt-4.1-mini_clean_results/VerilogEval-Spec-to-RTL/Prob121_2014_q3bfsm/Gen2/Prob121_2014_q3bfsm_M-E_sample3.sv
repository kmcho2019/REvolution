module TopModule(
    input clk,
    input reset,
    input x,
    output reg z
);

    // One-hot encoding of states: only one bit is high representing current state
    reg [4:0] state, next_state;

    // State bits for clarity
    localparam S0 = 5'b00001; // 000
    localparam S1 = 5'b00010; // 001
    localparam S2 = 5'b00100; // 010
    localparam S3 = 5'b01000; // 011
    localparam S4 = 5'b10000; // 100

    // Next state logic combinational
    always @(*) begin
        // Default next_state to 0 to avoid latches
        next_state = 5'b00000;

        case (1'b1) // Priority encoding on one-hot state bits
            state[0]: begin // S0 (000)
                if (x == 1'b0)
                    next_state = S0;
                else
                    next_state = S1;
            end
            state[1]: begin // S1 (001)
                if (x == 1'b0)
                    next_state = S1;
                else
                    next_state = S4;
            end
            state[2]: begin // S2 (010)
                if (x == 1'b0)
                    next_state = S2;
                else
                    next_state = S1;
            end
            state[3]: begin // S3 (011)
                if (x == 1'b0)
                    next_state = S1;
                else
                    next_state = S2;
            end
            state[4]: begin // S4 (100)
                if (x == 1'b0)
                    next_state = S3;
                else
                    next_state = S4;
            end
            default: begin
                next_state = S0; // Safe default if no bits set
            end
        endcase
    end

    // Output logic combinational: z=1 for S3 or S4, else 0
    always @(*) begin
        z = (state[3] | state[4]);
    end

    // State update on rising edge, synchronous reset active high
    always @(posedge clk) begin
        if (reset)
            state <= S0;
        else
            state <= next_state;
    end

endmodule