module TopModule (
    input  logic        clk,
    input  logic        resetn,
    input  logic [2:0]  r,
    output logic [2:0]  g
);

    typedef enum logic [1:0] {A, B, C, D} state_t;
    state_t state, next_state;

    // Synchronous state register with active-low synchronous reset
    always_ff @(posedge clk) begin
        if (!resetn)
            state <= A;
        else
            state <= next_state;
    end

    // Combinational next state logic with priority-based requests
    always_comb begin
        unique case (state)
            A: begin
                if (r[0])       next_state = B;
                else if (r[1])  next_state = C;
                else if (r[2])  next_state = D;
                else            next_state = A;
            end
            B: next_state = (r[0]) ? B : A;
            C: next_state = (r[1]) ? C : A;
            D: next_state = (r[2]) ? D : A;
            default: next_state = A;
        endcase
    end

    // Output grant signals as continuous assignments based on current state
    assign g = (state == B) ? 3'b001 :
               (state == C) ? 3'b010 :
               (state == D) ? 3'b100 :
                              3'b000;

endmodule