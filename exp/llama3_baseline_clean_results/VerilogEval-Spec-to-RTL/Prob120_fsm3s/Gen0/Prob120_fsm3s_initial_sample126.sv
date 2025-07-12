module TopModule (
    input  logic clk,
    input  logic reset,
    input  logic in,
    output logic out
);

// Define states
typedef enum logic [1:0] {
    A = 2'b00,
    B = 2'b01,
    C = 2'b10,
    D = 2'b11
} state_type;

state_type current_state, next_state;

// Next state logic
always_comb begin
    case (current_state)
        A: next_state = in ? B : A;
        B: next_state = in ? B : C;
        C: next_state = in ? D : A;
        D: next_state = in ? B : C;
    endcase
end

// Output logic
always_comb begin
    case (current_state)
        A, B, C: out = 0;
        D: out = 1;
    endcase
end

// State register
always_ff @(posedge clk) begin
    if (reset) begin
        current_state <= A;
    end else begin
        current_state <= next_state;
    end
end

endmodule