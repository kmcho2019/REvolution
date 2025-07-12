module TopModule (
    input clk,
    input reset,
    input in,
    output out
);

    reg state; // 0 for A, 1 for B

    always @(posedge clk) begin
        if (reset) begin
            state <= 1'b1; // Reset to B
        end else begin
            case (state)
                1'b0: state <= in ? 1'b0 : 1'b1; // A transitions
                1'b1: state <= in ? 1'b1 : 1'b0; // B transitions
                default: state <= 1'b1; // Fallback to B
            endcase
        end
    end

    assign out = state; // Direct output assignment

endmodule