module TopModule(
    input  clk,
    input  areset,
    input  in,
    output out
);

reg [0:0] state; // 0: A, 1: B
reg [0:0] next_state;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 1; // reset to state B
    end else begin
        case (state)
            0: begin // state A
                if (~in) begin
                    state <= 1; // transition to state B
                end else begin
                    state <= 0; // stay in state A
                end
            end
            1: begin // state B
                if (in) begin
                    state <= 1; // stay in state B
                end else begin
                    state <= 0; // transition to state A
                end
            end
        endcase
    end
end

always @(*) begin
    case (state)
        0: out <= 0; // state A
        1: out <= 1; // state B
    endcase
end

endmodule