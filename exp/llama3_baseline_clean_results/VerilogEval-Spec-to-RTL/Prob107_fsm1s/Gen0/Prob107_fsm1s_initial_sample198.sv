module TopModule(
    input  clk,
    input  reset,
    input  in,
    output out
);

reg [0:0] state; // 0: A, 1: B
reg [0:0] next_state;

always_comb begin
    case (state)
        0: out = 0; // state A, out = 0
        1: out = 1; // state B, out = 1
        default: out = 1; // default to state B
    endcase
end

always_ff @(posedge clk) begin
    if (reset) begin
        state <= 1; // reset to state B
    end else begin
        case (state)
            0: begin
                if (!in) state <= 1; // state A, in = 0, next state B
                else state <= 0; // state A, in = 1, next state A
            end
            1: begin
                if (!in) state <= 1; // state B, in = 0, next state B
                else state <= 1; // state B, in = 1, next state B
            end
            default: state <= 1; // default to state B
        endcase
    end
end

endmodule