module TopModule(
    input  logic clk,
    input  logic reset,
    input  logic in,
    output logic out
);

// Define states as an enum
enum logic [1:0] {
    A = 2'b00,
    B = 2'b01,
    C = 2'b10,
    D = 2'b11
} state, next_state;

// Sequential logic
always_ff @(posedge clk) begin
    if (reset) begin
        state <= A; // Reset to state A
    end else begin
        state <= next_state;
    end
end

// Combinational logic for next state and output
always_comb begin
    case (state)
        A: begin
            if (!in) next_state = A;
            else next_state = B;
            out = 0;
        end
        B: begin
            if (!in) next_state = C;
            else next_state = B;
            out = 0;
        end
        C: begin
            if (!in) next_state = A;
            else next_state = D;
            out = 0;
        end
        D: begin
            if (!in) next_state = C;
            else next_state = B;
            out = 1;
        end
        default: begin
            next_state = A;
            out = 0;
        end
    endcase
end

endmodule