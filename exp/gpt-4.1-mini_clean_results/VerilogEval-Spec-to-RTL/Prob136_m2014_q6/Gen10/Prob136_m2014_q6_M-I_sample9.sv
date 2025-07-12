module TopModule(
    input clk,
    input reset,
    input w,
    output z
);

    // Binary encoding of states (3 bits)
    localparam [2:0]
        A = 3'd0,
        B = 3'd1,
        C = 3'd2,
        D = 3'd3,
        E = 3'd4,
        F = 3'd5;

    reg [2:0] state, next_state;

    // Next state logic using case statement for better synthesis optimization
    always @(*) begin
        case (state)
            A: next_state = (w == 1'b0) ? B : A;
            B: next_state = (w == 1'b0) ? C : D;
            C: next_state = (w == 1'b0) ? E : D;
            D: next_state = (w == 1'b0) ? F : A;
            E: next_state = (w == 1'b0) ? E : D;
            F: next_state = (w == 1'b0) ? C : D;
            default: next_state = A;
        endcase
    end

    // State register update
    always @(posedge clk) begin
        if (reset)
            state <= A;
        else
            state <= next_state;
    end

    // Output z: high only in states E and F (4 and 5), which have bit 2 = 1 and bit 1 = 0 or 1
    // Since E=4(100), F=5(101), checking if state[2] == 1 and state < 6 covers both
    assign z = (state[2] == 1'b1) && (state <= F);

endmodule