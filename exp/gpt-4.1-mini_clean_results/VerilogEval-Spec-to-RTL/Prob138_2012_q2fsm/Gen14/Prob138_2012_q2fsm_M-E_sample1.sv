module TopModule (
    input  clk,
    input  reset,
    input  w,
    output z
);

    // One-hot encoding for states: 6 bits, each representing one state
    // state[0] = A, state[1] = B, state[2] = C, state[3] = D, state[4] = E, state[5] = F
    reg [5:0] state, next_state;

    // Sequential logic: state register with synchronous active-high reset
    always @(posedge clk) begin
        if (reset)
            state <= 6'b000001; // A active
        else
            state <= next_state;
    end

    // Combinational logic: next state decoding
    always @(*) begin
        // Default next_state to all zero to avoid latches
        next_state = 6'b000000;

        if (state[0]) begin // A
            next_state = w ? 6'b000010 : 6'b000001; // B : A
        end else if (state[1]) begin // B
            next_state = w ? 6'b000100 : 6'b0001000; // C : D
        end else if (state[2]) begin // C
            next_state = w ? 6'b001000 : 6'b0001000; // E : D
        end else if (state[3]) begin // D
            next_state = w ? 6'b100000 : 6'b0000001; // F : A
        end else if (state[4]) begin // E
            next_state = w ? 6'b001000 : 6'b0001000; // E : D
        end else if (state[5]) begin // F
            next_state = w ? 6'b000100 : 6'b0001000; // C : D
        end else begin
            // If none active, reset to A
            next_state = 6'b000001;
        end
    end

    // Output z is 1 only in state E (state[4])
    assign z = state[4];

endmodule