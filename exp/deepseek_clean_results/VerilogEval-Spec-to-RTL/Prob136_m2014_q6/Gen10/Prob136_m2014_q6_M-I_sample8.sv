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

    reg [5:0] current_state, next_state;
    wire clk_enable = (current_state != next_state) || reset;

    // Combinational next state logic with parallel case optimization
    always @(*) begin
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

    // Clock-gated sequential state update
    always @(posedge clk) begin
        if (reset) begin
            current_state <= A;
        end else if (clk_enable) begin
            current_state <= next_state;
        end
    end

    // Output is simply the MSB of the one-hot encoded state (F or E)
    assign z = current_state[5] | current_state[4];

endmodule