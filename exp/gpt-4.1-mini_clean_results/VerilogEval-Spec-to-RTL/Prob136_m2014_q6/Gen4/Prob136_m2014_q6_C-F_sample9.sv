module TopModule (
    input clk,
    input reset,
    input w,
    output reg z
);

    // State encoding using parameters for clarity and simplicity
    parameter A = 3'd0, B = 3'd1, C = 3'd2, D = 3'd3, E = 3'd4, F = 3'd5;

    reg [2:0] state, next_state;

    // Next state logic using a clean case statement
    always @(*) begin
        case(state)
            A: next_state = (w == 1'b0) ? B : A;
            B: next_state = (w == 1'b0) ? C : D;
            C: next_state = (w == 1'b0) ? E : D;
            D: next_state = (w == 1'b0) ? F : A;
            E: next_state = (w == 1'b0) ? E : D;
            F: next_state = (w == 1'b0) ? C : D;
            default: next_state = A; // safety default
        endcase
    end

    // State register update on positive clock edge, synchronous reset
    always @(posedge clk) begin
        if (reset)
            state <= A;
        else
            state <= next_state;
    end

    // Output logic using a case statement for clarity
    always @(*) begin
        case(state)
            E, F: z = 1'b1;
            default: z = 1'b0;
        endcase
    end

endmodule