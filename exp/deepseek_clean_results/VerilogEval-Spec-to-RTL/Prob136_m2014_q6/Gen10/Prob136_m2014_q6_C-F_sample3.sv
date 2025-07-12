module TopModule (
    input clk,
    input reset,
    input w,
    output z
);

    // Gray-coded state encoding with explicit localparams
    localparam [2:0] A = 3'b000,
                     B = 3'b001,
                     C = 3'b011,
                     D = 3'b010,
                     E = 3'b110,
                     F = 3'b100;

    reg [2:0] current_state, next_state;

    // Combinational next state logic
    always @(*) begin
        case (current_state)
            A: next_state = w ? A : B;
            B: next_state = w ? D : C;
            C: next_state = w ? D : E;
            D: next_state = w ? A : F;
            E: next_state = w ? D : E;
            F: next_state = w ? D : C;
            default: next_state = A;  // Handle unexpected states
        endcase
    end

    // Sequential state storage with synchronous reset
    always @(posedge clk) begin
        if (reset)
            current_state <= A;
        else
            current_state <= next_state;
    end

    // Direct output assignment from state bit
    assign z = current_state[2];

endmodule