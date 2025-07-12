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

    // Next state logic combinational assignment
    assign next_state = (state == A) ? ((w == 1'b0) ? B : A) :
                        (state == B) ? ((w == 1'b0) ? C : D) :
                        (state == C) ? ((w == 1'b0) ? E : D) :
                        (state == D) ? ((w == 1'b0) ? F : A) :
                        (state == E) ? ((w == 1'b0) ? E : D) :
                        (state == F) ? ((w == 1'b0) ? C : D) :
                        A;  // default to A on invalid state

    // State register update
    always @(posedge clk) begin
        if (reset)
            state <= A;
        else
            state <= next_state;
    end

    // Output z: high in states E or F
    assign z = (state == E) || (state == F);

endmodule