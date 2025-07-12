module TopModule(
    input clk,
    input reset,
    input in,
    output reg out
);

reg state; // 0 for state A, 1 for state B

always @ (posedge clk) begin
    if (reset) begin
        state <= 1; // reset to state B
    end else begin
        case (state)
            1'b0: begin // state A
                if (!in) begin
                    state <= 1; // in=0, go to state B
                end else begin
                    state <= 0; // in=1, stay in state A
                end
            end
            1'b1: begin // state B
                if (!in) begin
                    state <= 1; // in=0, stay in state B
                end else begin
                    state <= 1; // in=1, stay in state B
                end
            end
        endcase
    end
end

always @ (*) begin
    case (state)
        1'b0: out = 1'b0; // state A, out=0
        1'b1: out = 1'b1; // state B, out=1
    endcase
end

endmodule