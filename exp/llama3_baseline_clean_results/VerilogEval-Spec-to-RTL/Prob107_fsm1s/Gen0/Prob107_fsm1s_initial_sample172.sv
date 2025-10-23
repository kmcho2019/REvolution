module TopModule(
    input clk,
    input reset,
    input in,
    output logic out
);

enum logic [0:0] {B, A} state, next_state;

always_comb begin
    case (state)
        B: next_state = (in == 0) ? A : B;
        A: next_state = (in == 0) ? B : A;
        default: next_state = B;
    endcase
end

always_ff @(posedge clk) begin
    if (reset) begin
        state <= B;
        out <= 1'b1;
    end else begin
        state <= next_state;
        case (state)
            B: out <= 1'b1;
            A: out <= 1'b0;
            default: out <= 1'b1;
        endcase
    end
end

endmodule