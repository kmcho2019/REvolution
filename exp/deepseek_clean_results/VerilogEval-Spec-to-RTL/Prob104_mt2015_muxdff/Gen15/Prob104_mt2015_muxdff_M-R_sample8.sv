module TopModule #(
    parameter BIT_POS = 0
) (
    input clk,
    input L,
    input r_in,     // Load value input
    input q0_in,    // Current q[0] value (for bit 1)
    input q1_in,    // Current q[1] value (for bit 0)
    input q2_in,    // Current q[2] value (for bit 0)
    output reg Q    // Registered output
);

    // Feedback operation logic
    wire feedback;
    assign feedback = (BIT_POS == 0) ? (q1_in ^ q2_in) :  // Bit 0: XOR
                      (BIT_POS == 1) ? q0_in :            // Bit 1: pass q0
                      Q;                                  // Bit 2: hold

    // Mux selects between load and feedback operation
    wire next_Q = L ? r_in : feedback;

    // Sequential logic (D flip-flop)
    always @(posedge clk) begin
        Q <= next_Q;
    end

endmodule