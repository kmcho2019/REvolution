module TopModule(
    input  clk,
    input  reset,
    input  in,
    output out
);

// Enum for states
enum logic [0:0] {B, A} state, next_state;

always_ff @(posedge clk) begin
    if (reset) begin
        state <= B;
    end else begin
        case (state)
            B: begin
                if (!in) begin
                    state <= A;
                end else begin
                    state <= B;
                end
            end
            A: begin
                if (!in) begin
                    state <= B;
                end else begin
                    state <= A;
                end
            end
            default: state <= B;
        endcase
    end
end

always_comb begin
    case (state)
        B: out = 1'b1;
        A: out = 1'b0;
        default: out = 1'b1;
    endcase
end

endmodule