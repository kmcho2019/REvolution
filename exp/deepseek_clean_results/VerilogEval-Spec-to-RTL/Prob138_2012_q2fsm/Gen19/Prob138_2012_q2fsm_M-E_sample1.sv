module TopModule (
    input clk,
    input reset,
    input w,
    output z
);

    // Novel 4-bit state encoding with output and parity
    parameter [3:0] 
        A = 4'b0000,
        B = 4'b0001,
        C = 4'b0011,
        D = 4'b0010,
        E = 4'b1110,
        F = 4'b1100;

    reg [3:0] current_state, next_state;

    // Parallel state prediction logic
    always @(*) begin
        case ({current_state, w})
            {A, 1'b0}: next_state = A;
            {A, 1'b1}: next_state = B;
            {B, 1'b0}: next_state = D;
            {B, 1'b1}: next_state = C;
            {C, 1'b0}: next_state = D;
            {C, 1'b1}: next_state = E;
            {D, 1'b0}: next_state = A;
            {D, 1'b1}: next_state = F;
            {E, 1'b0}: next_state = D;
            {E, 1'b1}: next_state = E;
            {F, 1'b0}: next_state = D;
            {F, 1'b1}: next_state = C;
            default:   next_state = A;  // Recovery for undefined states
        endcase
    end

    // State storage with synchronous reset
    always @(posedge clk) begin
        if (reset) current_state <= A;
        else current_state <= next_state;
    end

    // Direct output mapping from state MSB
    assign z = current_state[3];

endmodule