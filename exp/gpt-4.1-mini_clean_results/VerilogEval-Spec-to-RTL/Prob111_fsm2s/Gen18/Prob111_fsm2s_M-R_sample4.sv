module TopModule(
    input clk,
    input reset,
    input j,
    input k,
    output out
);

    reg state; // 0: OFF, 1: ON

    // Moore output directly assigned from state
    assign out = state;

    always @(posedge clk) begin
        if (reset) begin
            state <= 1'b0; // OFF state
        end else begin
            case (state)
                1'b0: // OFF
                    state <= j ? 1'b1 : 1'b0;
                1'b1: // ON
                    state <= k ? 1'b0 : 1'b1;
                default:
                    state <= 1'b0; // Safe default to OFF
            endcase
        end
    end

endmodule