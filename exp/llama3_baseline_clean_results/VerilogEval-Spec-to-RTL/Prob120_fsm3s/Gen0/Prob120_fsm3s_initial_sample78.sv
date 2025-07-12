module TopModule(
    input  logic clk,
    input  logic reset,
    input  logic in,
    output logic out
);

// Define states
enum logic [1:0] {A, B, C, D} current_state, next_state;

always_ff @(posedge clk) begin
    if (reset) begin
        current_state <= A;
    end else begin
        current_state <= next_state;
    end
end

always_comb begin
    case (current_state)
        A: next_state = in ? B : A;
        B: next_state = in ? B : C;
        C: next_state = in ? D : A;
        D: next_state = in ? B : C;
        default: next_state = A; // Handle default case, though it should not occur
    endcase
end

always_comb begin
    case (current_state)
        A, B, C: out = 0;
        D: out = 1;
        default: out = 0; // Handle default case, though it should not occur
    endcase
end

endmodule