module TopModule (
    input clk,
    input reset,
    input w,
    output z
);

    // Gray-coded state encoding with explicit localparams
    localparam [2:0] 
        A = 3'b000,
        B = 3'b001,
        C = 3'b011,
        D = 3'b010,
        E = 3'b110,
        F = 3'b100;

    reg [2:0] state;

    // Modular next state function
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

    // Output is MSB of state (E and F states)
    assign z = state[2];

endmodule