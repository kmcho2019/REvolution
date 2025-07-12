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

    // Next state logic using a combinational case statement for clarity and synthesis friendliness
    always @(*) begin
        case (state)
            A: next_state = (w == 1'b0) ? B : A;
            B: next_state = (w == 1'b0) ? C : D;
            C: next_state = (w == 1'b0) ? E : D;
            D: next_state = (w == 1'b0) ? F : A;
            E: next_state = (w == 1'b0) ? E : D;
            F: next_state = (w == 1'b0) ? C : D;
            default: next_state = A;  // Recover to A on invalid state
        endcase
    end

    // State register with synchronous reset and non-blocking assignment
    always @(posedge clk) begin
        if (reset)
            state <= A;
        else
            state <= next_state;
    end

    // Output z asserted when in states E or F
    assign z = (state == E) || (state == F);

endmodule