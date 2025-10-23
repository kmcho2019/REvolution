module TopModule (
    input clk,
    input reset,
    input w,
    output z
);

    // Gray-coded state encoding with localparam
    localparam [2:0] 
        A = 3'b000,
        B = 3'b001,
        C = 3'b011,
        D = 3'b010,
        E = 3'b110,
        F = 3'b100;

    reg [2:0] state, next_state;

    // Modular next state function with unique case
    function [2:0] next_state_func;
        input [2:0] current;
        input w;
        begin
            unique case (current)
                A: next_state_func = w ? A : B;
                B: next_state_func = w ? D : C;
                C: next_state_func = w ? D : E;
                D: next_state_func = w ? A : F;
                E: next_state_func = w ? D : E;
                F: next_state_func = w ? D : C;
            endcase
        end
    endfunction

    // Combinational next-state logic
    always @(*) begin
        next_state = next_state_func(state, w);
    end

    // Sequential state register
    always @(posedge clk) begin
        if (reset)
            state <= A;
        else
            state <= next_state;
    end

    // Direct output assignment from state bit
    assign z = state[2];

endmodule