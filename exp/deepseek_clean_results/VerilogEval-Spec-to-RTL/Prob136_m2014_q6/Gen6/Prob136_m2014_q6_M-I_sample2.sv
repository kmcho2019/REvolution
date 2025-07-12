module TopModule (
    input clk,
    input reset,
    input w,
    output z
);

    // One-hot state encoding
    localparam 
        A = 6'b000001,
        B = 6'b000010,
        C = 6'b000100,
        D = 6'b001000,
        E = 6'b010000,
        F = 6'b100000;

    reg [5:0] current_state, next_state;

    // Combinational next state logic with parallel case
    always @(*) begin
        // Default to avoid latches
        next_state = A;
        
        // synthesis parallel_case
        case (1'b1) // synthesis parallel_case
            current_state[A]: next_state = w ? A : B;
            current_state[B]: next_state = w ? D : C;
            current_state[C]: next_state = w ? D : E;
            current_state[D]: next_state = w ? A : F;
            current_state[E]: next_state = w ? D : E;
            current_state[F]: next_state = w ? D : C;
            default: next_state = A;
        endcase
    end

    // Sequential state update
    always @(posedge clk) begin
        if (reset) begin
            current_state <= A;
        end else begin
            current_state <= next_state;
        end
    end

    // Output is 1 when in state E or F
    assign z = current_state[E] | current_state[F];

endmodule