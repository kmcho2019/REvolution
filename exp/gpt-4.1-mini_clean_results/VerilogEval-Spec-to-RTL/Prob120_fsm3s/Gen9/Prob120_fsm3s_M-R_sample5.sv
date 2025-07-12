module TopModule (
    input  clk,
    input  reset,
    input  in,
    output reg out
);

    // State encoding with typedef enum for clarity
    typedef enum logic [1:0] {
        A = 2'b00,
        B = 2'b01,
        C = 2'b10,
        D = 2'b11
    } state_t;

    state_t state, next_state;

    // Next state combinational logic
    always @(*) begin
        case (state)
            A: next_state = in ? B : A;
            B: next_state = in ? B : C;
            C: next_state = in ? D : A;
            D: next_state = in ? B : C;
            default: next_state = A;
        endcase
    end

    // State register with synchronous reset
    always @(posedge clk) begin
        if (reset)
            state <= A;
        else
            state <= next_state;
    end

    // Registered Moore output logic: output depends on current state
    always @(posedge clk) begin
        if (reset)
            out <= 1'b0;
        else
            out <= (state == D);
    end

endmodule