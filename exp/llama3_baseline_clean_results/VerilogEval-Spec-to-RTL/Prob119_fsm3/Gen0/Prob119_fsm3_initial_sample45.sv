module TopModule (
    input  logic clk,
    input  logic areset,
    input  logic in,
    output logic out
);

enum logic [1:0] {A, B, C, D} state, next_state;

always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= A;
    end else begin
        state <= next_state;
    end
end

always_comb begin
    case (state)
        A: next_state = in ? B : A;
        B: next_state = in ? B : C;
        C: next_state = in ? D : A;
        D: next_state = in ? B : C;
    endcase
end

always_comb begin
    case (state)
        A, B, C: out = 0;
        D: out = 1;
    endcase
end

endmodule