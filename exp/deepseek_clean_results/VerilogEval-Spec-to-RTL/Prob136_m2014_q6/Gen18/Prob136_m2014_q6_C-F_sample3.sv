module TopModule (
    input clk,
    input reset,
    input w,
    output z
);

    // Optimized Gray-coded state encoding with single-bit transitions
    // between frequently connected states (A<->B, B<->D, etc.)
    // z output is directly state[2] (1 for E and F states)
    localparam [2:0] 
        A = 3'b000,  // z=0
        B = 3'b001,  // z=0
        C = 3'b011,  // z=0
        D = 3'b010,  // z=0
        E = 3'b110,  // z=1
        F = 3'b100;  // z=1

    reg [2:0] state;

    // Modular next state function with optimized case structure
    function [2:0] next_state;
        input [2:0] current;
        input w;
        begin
            case (current)
                A: next_state = w ? A : B;
                B: next_state = w ? D : C;
                C: next_state = w ? D : E;
                D: next_state = w ? A : F;
                E: next_state = w ? D : E;
                F: next_state = w ? D : C;
            endcase
        end
    endfunction

    // State transition logic
    always @(posedge clk) begin
        if (reset)
            state <= A;
        else
            state <= next_state(state, w);
    end

    // Output is directly from state bit 2 (MSB)
    assign z = state[2];

endmodule