module TopModule (
    input clk,
    input reset,
    input w,
    output z
);

    // Gray code state encoding (optimized for transitions)
    parameter [2:0] A = 3'b000,
                    B = 3'b001,
                    C = 3'b011,
                    D = 3'b010,
                    E = 3'b110,
                    F = 3'b111;

    reg [2:0] current_state;

    // Function for modular next-state calculation
    function [2:0] get_next_state;
        input [2:0] state;
        input w;
        begin
            case (state)
                A: get_next_state = w ? A : B;
                B: get_next_state = w ? D : C;
                C: get_next_state = w ? D : E;
                D: get_next_state = w ? A : F;
                E: get_next_state = w ? D : E;
                F: get_next_state = w ? D : C;
                default: get_next_state = A;
            endcase
        end
    endfunction

    // Sequential state update
    always @(posedge clk) begin
        if (reset)
            current_state <= A;
        else
            current_state <= get_next_state(current_state, w);
    end

    // Direct output assignment for optimal timing
    assign z = current_state[2];

endmodule