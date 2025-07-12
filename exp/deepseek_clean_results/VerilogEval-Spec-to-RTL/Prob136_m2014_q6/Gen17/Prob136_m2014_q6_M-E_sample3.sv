module TopModule (
    input clk,
    input reset,
    input w,
    output z
);

    // Binary state encoding
    localparam [2:0] 
        A = 3'b000,
        B = 3'b001,
        C = 3'b010,
        D = 3'b011,
        E = 3'b100,
        F = 3'b101;

    reg [2:0] state;

    // Next state logic as binary decision tree
    wire [2:0] next_state = 
        (state == A) ? (w ? A : B) :
        (state == B) ? (w ? D : C) :
        (state == C) ? (w ? D : E) :
        (state == D) ? (w ? A : F) :
        (state == E) ? (w ? D : E) :
        (state == F) ? (w ? D : C) :
        A;  // Default case (should never occur)

    // State register
    always @(posedge clk) begin
        if (reset)
            state <= A;
        else
            state <= next_state;
    end

    // Output is high for states E (100) or F (101) - detect bit 2
    assign z = state[2];

endmodule