module TopModule(
    input clk,
    input reset,
    input in,
    output reg out
);

// Enum for states
typedef enum logic [1:0] {
    A = 2'b00,
    B = 2'b01,
    C = 2'b10,
    D = 2'b11
} state_t;

reg [1:0] current_state;

always @ (posedge clk) begin
    if (reset) begin
        current_state <= A;
    end else begin
        case (current_state)
            A: current_state <= in ? B : A;
            B: current_state <= in ? B : C;
            C: current_state <= in ? D : A;
            D: current_state <= in ? B : C;
            default: current_state <= A; // Default to state A if current state is unknown
        endcase
    end
end

always @ (*) begin
    case (current_state)
        A, B, C: out = 0;
        D: out = 1;
        default: out = 0; // Default output to 0 if current state is unknown
    endcase
end

endmodule