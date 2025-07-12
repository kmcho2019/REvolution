module TopModule(
    input clk,
    input reset,
    input w,
    output reg z
);

    // State encoding using localparam for clarity and synthesis guidance
    localparam [2:0] A = 3'd0,
                     B = 3'd1,
                     C = 3'd2,
                     D = 3'd3,
                     E = 3'd4,
                     F = 3'd5;

    reg [2:0] state, next_state;

    // Next state logic using case statement for clarity and efficient synthesis
    always @(*) begin
        case (state)
            A: next_state = w ? A : B;
            B: next_state = w ? D : C;
            C: next_state = w ? D : E;
            D: next_state = w ? A : F;
            E: next_state = w ? D : E;
            F: next_state = w ? D : C;
            default: next_state = A;
        endcase
    end

    // Sequential logic with synchronous reset and non-blocking assignment
    always @(posedge clk) begin
        if (reset)
            state <= A;
        else
            state <= next_state;
    end

    // Output logic: output z is the MSB of the state register for states E and F
    always @(*) begin
        z = state[2];
    end

endmodule