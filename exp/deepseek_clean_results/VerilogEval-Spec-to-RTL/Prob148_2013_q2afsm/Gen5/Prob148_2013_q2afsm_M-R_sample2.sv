module TopModule (
    input clk,
    input resetn,
    input [2:0] r,
    output [2:0] g
);

    // State encoding using enum for better readability
    typedef enum logic [1:0] {
        A = 2'b00,
        B = 2'b01,
        C = 2'b10,
        D = 2'b11
    } state_t;

    state_t current_state, next_state;

    // State transition logic using continuous assignments
    assign next_state = 
        (current_state == A) ? 
            (r[0] ? B : 
             r[1] ? C : 
             r[2] ? D : A) :
        (current_state == B) ? (r[0] ? B : A) :
        (current_state == C) ? (r[1] ? C : A) :
        (current_state == D) ? (r[2] ? D : A) : A;

    // State storage (sequential logic)
    always @(posedge clk) begin
        if (!resetn) current_state <= A;
        else         current_state <= next_state;
    end

    // Output logic - direct assignments
    assign g[0] = (current_state == B);
    assign g[1] = (current_state == C);
    assign g[2] = (current_state == D);

endmodule