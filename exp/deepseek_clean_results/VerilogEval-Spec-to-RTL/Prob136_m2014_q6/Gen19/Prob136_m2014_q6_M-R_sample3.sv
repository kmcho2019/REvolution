module TopModule (
    input clk,
    input reset,
    input w,
    output z
);

    // One-hot encoded states
    localparam A = 6'b000001,
               B = 6'b000010,
               C = 6'b000100,
               D = 6'b001000,
               E = 6'b010000,
               F = 6'b100000;

    reg [5:0] state, next_state;

    // State transitions (combinational logic)
    assign next_state = reset ? A : (
        (state == A) ? (w ? A : B) :
        (state == B) ? (w ? D : C) :
        (state == C) ? (w ? D : E) :
        (state == D) ? (w ? A : F) :
        (state == E) ? (w ? D : E) :
        (state == F) ? (w ? D : C) :
        A  // default case
    );

    // State register (sequential logic)
    always @(posedge clk) begin
        state <= next_state;
    end

    // Output logic (z is high for states E or F)
    assign z = (state == E) | (state == F);

endmodule