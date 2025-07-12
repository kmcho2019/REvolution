module TopModule(
    input clk,
    input reset,
    input in,
    output out
);

// Define states as an enumeration
typedef enum logic [1:0] {
    A = 2'b00,
    B = 2'b01,
    C = 2'b10,
    D = 2'b11
} state_type;

state_type current_state;

always_ff @(posedge clk or posedge reset) begin
    if (reset) begin
        current_state <= A; // Reset to state A
    end else begin
        case (current_state)
            A: current_state <= in ? B : A;
            B: current_state <= in ? B : C;
            C: current_state <= in ? D : A;
            D: current_state <= in ? B : C;
            default: current_state <= A; // Should not reach here
        endcase
    end
end

always_comb begin
    case (current_state)
        A, B, C: out = 1'b0;
        D: out = 1'b1;
        default: out = 1'b0; // Should not reach here
    endcase
end

endmodule