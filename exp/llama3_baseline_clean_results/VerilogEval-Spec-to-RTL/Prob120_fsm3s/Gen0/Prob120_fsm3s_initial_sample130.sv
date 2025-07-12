module TopModule(
    input clk,
    input reset,
    input in,
    output reg out
);

// Define the states
enum logic [1:0] {A, B, C, D} state, next_state;

always @(*) begin
    case (state)
        A: next_state = (in) ? B : A;
        B: next_state = (in) ? B : C;
        C: next_state = (in) ? D : A;
        D: next_state = (in) ? B : C;
    endcase
end

always @(posedge clk) begin
    if (reset) begin
        state <= A;
        out <= 0;
    end else begin
        state <= next_state;
        case (state)
            A, B, C: out <= 0;
            D: out <= 1;
        endcase
    end
end

initial state = A;

endmodule