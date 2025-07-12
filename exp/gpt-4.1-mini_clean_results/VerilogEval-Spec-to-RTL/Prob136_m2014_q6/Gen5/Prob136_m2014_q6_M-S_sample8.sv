module TopModule (
    input clk,
    input reset,
    input w,
    output reg z
);

    // State encoding
    parameter A = 3'd0, B = 3'd1, C = 3'd2, D = 3'd3, E = 3'd4, F = 3'd5;

    reg [2:0] state, next_state;

    // Next state logic using case statement
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

    // Output logic: z is 1 only in states E and F
    always @(*) begin
        z = (state == E || state == F) ? 1'b1 : 1'b0;
    end

endmodule