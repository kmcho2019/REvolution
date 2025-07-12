module TopModule(
    input clk,
    input areset,
    input in,
    output reg out
);

// Define states as an enumeration
enum logic [1:0] {A, B, C, D} current_state, next_state;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        // Reset to state A
        current_state <= A;
        out <= 1'b0;  // According to state transition table, output is 0 in state A
    end else begin
        // Update current state
        current_state <= next_state;
        
        // Determine output based on the current state
        case (current_state)
            A: out <= 1'b0;
            B: out <= 1'b0;
            C: out <= 1'b0;
            D: out <= 1'b1;
        endcase
    end
end

always @(*) begin
    // Determine next state based on current state and input 'in'
    case (current_state)
        A: next_state = in ? B : A;
        B: next_state = in ? B : C;
        C: next_state = in ? D : A;
        D: next_state = in ? B : C;
    endcase
end

initial begin
    // Initialize current state to A
    current_state = A;
end

endmodule