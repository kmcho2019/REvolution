module TopModule(
    input clk,
    input reset,
    input in,
    output reg out
);

reg state; // '0' represents state B, '1' represents state A

always @ (posedge clk) begin
    if (reset) begin // synchronous reset, active-high
        state <= 0; // reset to state B
    end else begin
        case (state)
            0: begin // state B
                if (!in) begin // in = 0
                    state <= 1; // transition to state A
                end else begin // in = 1
                    state <= 0; // stay in state B
                end
            end
            1: begin // state A
                if (!in) begin // in = 0
                    state <= 0; // transition to state B
                end else begin // in = 1
                    state <= 1; // stay in state A
                end
            end
            default: state <= 0; // default to state B
        endcase
    end
end

always @ (*) begin
    case (state)
        0: out = 1; // output is 1 in state B
        1: out = 0; // output is 0 in state A
        default: out = 1; // default output
    endcase
end

endmodule