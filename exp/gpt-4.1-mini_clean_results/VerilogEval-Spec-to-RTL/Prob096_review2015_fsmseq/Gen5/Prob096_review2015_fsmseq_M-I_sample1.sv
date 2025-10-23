module TopModule(
    input  clk,
    input  reset,
    input  data,
    output start_shifting
);

    // One-hot state encoding (5 states, 5 bits)
    // s0: no match (initial)
    // s1: matched '1'
    // s2: matched "11"
    // s3: matched "110"
    // s4: matched "1101" (final detected state)
    reg [4:0] state, next_state;

    // State bits for readability
    wire s0 = state[0];
    wire s1 = state[1];
    wire s2 = state[2];
    wire s3 = state[3];
    wire s4 = state[4];

    always @(posedge clk) begin
        if (reset)
            state <= 5'b00001;  // s0 initial state
        else
            state <= next_state;
    end

    always @(*) begin
        // Default next state zeroed
        next_state = 5'b00000;

        if (s4) begin
            // Once final detected state reached, remain there
            next_state = 5'b10000;
        end else if (s0) begin
            // From s0: if data=1 -> s1 else s0
            next_state = data ? 5'b00010 : 5'b00001;
        end else if (s1) begin
            // From s1: if data=1 -> s2 else s0
            next_state = data ? 5'b00100 : 5'b00001;
        end else if (s2) begin
            // From s2: if data=1 -> s2 else s3
            next_state = data ? 5'b00100 : 5'b01000;
        end else if (s3) begin
            // From s3: if data=1 -> s4 else s0
            next_state = data ? 5'b10000 : 5'b00001;
        end else begin
            // Safety fallback to initial
            next_state = 5'b00001;
        end
    end

    assign start_shifting = s4;

endmodule