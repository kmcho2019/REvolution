module TopModule (
    input  clk,
    input  areset,
    input  in,
    output reg out
);

    // Enumerated state encoding
    typedef enum reg [0:0] {A = 1'b0, B = 1'b1} state_t;

    state_t state, next_state;

    // Next state logic (combinational)
    always @(*) begin
        case (state)
            B: next_state = in ? B : A;
            A: next_state = in ? A : B;
            default: next_state = B;  // safe default
        endcase
    end

    // State register with asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= B;
        else
            state <= next_state;
    end

    // Moore output logic: output depends only on state
    always @(posedge clk or posedge areset) begin
        if (areset)
            out <= 1'b1; // output of state B
        else
            out <= (state == B) ? 1'b1 : 1'b0;
    end

endmodule