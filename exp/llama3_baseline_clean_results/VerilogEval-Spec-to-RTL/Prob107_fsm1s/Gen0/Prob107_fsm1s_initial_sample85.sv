module TopModule(
    input clk,
    input reset,
    input in,
    output out
);

reg [0:0] state; // 0: A, 1: B

always @ (posedge clk) begin
    if (reset) begin
        state <= 1; // reset state is B
    end else begin
        case (state)
            1'b1: begin // state B
                if (~in) begin
                    state <= 0; // in = 0, go to state A
                end else begin
                    state <= 1; // in = 1, stay in state B
                end
            end
            1'b0: begin // state A
                if (~in) begin
                    state <= 1; // in = 0, go to state B
                end else begin
                    state <= 0; // in = 1, stay in state A
                end
            end
            default: state <= 1; // default to state B
        endcase
    end
end

always @ (*) begin
    case (state)
        1'b1: out = 1'b1; // state B output is 1
        1'b0: out = 1'b0; // state A output is 0
        default: out = 1'b1; // default to output 1
    endcase
end

endmodule