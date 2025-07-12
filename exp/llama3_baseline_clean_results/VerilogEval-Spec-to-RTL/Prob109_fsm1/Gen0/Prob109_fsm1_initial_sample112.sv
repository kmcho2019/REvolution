module TopModule(
    input clk,
    input areset,
    input in,
    output reg out
);

reg state; // 0: state A, 1: state B
always @(posedge clk or posedge areset) begin
    if(areset) begin
        state <= 1; // Reset to state B
    end else begin
        case(state)
            1'b1: // State B
                begin
                    if(in) begin
                        state <= 1; // Stay in state B
                    end else begin
                        state <= 0; // Move to state A
                    end
                end
            1'b0: // State A
                begin
                    if(in) begin
                        state <= 0; // Stay in state A
                    end else begin
                        state <= 1; // Move to state B
                    end
                end
        endcase
    end
end

always @(state) begin
    case(state)
        1'b1: // State B
            out <= 1;
        1'b0: // State A
            out <= 0;
    endcase
end

endmodule