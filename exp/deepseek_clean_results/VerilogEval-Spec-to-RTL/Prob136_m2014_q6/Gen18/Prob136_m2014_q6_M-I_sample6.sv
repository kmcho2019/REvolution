module TopModule (
    input clk,
    input reset,
    input w,
    output z
);

    // One-hot state encoding (6 states)
    localparam [5:0] 
        A = 6'b000001,
        B = 6'b000010,
        C = 6'b000100,
        D = 6'b001000,
        E = 6'b010000,
        F = 6'b100000;

    reg [5:0] current_state;

    // Combinational next state logic
    always @(*) begin
        case (1'b1) // synthesis parallel_case
            current_state[A]: current_state = w ? A : B;
            current_state[B]: current_state = w ? D : C;
            current_state[C]: current_state = w ? D : E;
            current_state[D]: current_state = w ? A : F;
            current_state[E]: current_state = w ? D : E;
            current_state[F]: current_state = w ? D : C;
            default: current_state = A;
        endcase
    end

    // State register with synchronous reset
    always @(posedge clk) begin
        if (reset)
            current_state <= A;
        else
            current_state <= next_state;
    end

    // Output logic - explicit case for better optimization
    assign z = current_state[E] | current_state[F];

endmodule