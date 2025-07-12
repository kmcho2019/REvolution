module TopModule (
    input clk,
    input reset,
    input w,
    output z
);

    // Optimized Gray-coded state encoding
    localparam [2:0] 
        A = 3'b000,  // 0
        B = 3'b001,  // 1
        D = 3'b010,  // 2 (placed between B and C for Gray coding)
        C = 3'b011,  // 3
        F = 3'b100,  // 4
        E = 3'b110;  // 6

    reg [2:0] state, next_state;

    // Combinational next state logic
    always @(*) begin
        case (state)
            A: next_state = w ? A : B;
            B: next_state = w ? D : C;
            C: next_state = w ? D : E;
            D: next_state = w ? A : F;
            E: next_state = w ? D : E;
            F: next_state = w ? D : C;
        endcase
    end

    // Sequential state update
    always @(posedge clk) begin
        if (reset)
            state <= A;
        else
            state <= next_state;
    end

    // Output is MSB of state (1 for E and F)
    assign z = state[2];

endmodule