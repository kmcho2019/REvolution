module TopModule(
    input           clk,
    input           areset,
    input           in,
    output          out
);

reg [0:0] state; // 0 for state A, 1 for state B

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 1'b1; // asynchronously reset to state B
    end else begin
        case (state)
            1'b0: begin // state A
                if (in) begin
                    state <= 1'b0; // stay in state A
                end else begin
                    state <= 1'b1; // transition to state B
                end
            end
            1'b1: begin // state B
                if (in) begin
                    state <= 1'b1; // stay in state B
                end else begin
                    state <= 1'b0; // transition to state A
                end
            end
        endcase
    end
end

always @(*) begin
    case (state)
        1'b0: out = 1'b0; // output 0 in state A
        1'b1: out = 1'b1; // output 1 in state B
    endcase
end

endmodule