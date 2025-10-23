module TopModule (
    input clk,
    input reset,
    input in,
    output out
);

    // State encoding
    reg state; // 0=B, 1=A

    // Combined state transition and output logic
    always @(posedge clk) begin
        if (reset)
            state <= 1'b0; // Reset to state B
        else begin
            case (state)
                1'b0: state <= in ? 1'b0 : 1'b1; // B transitions
                1'b1: state <= in ? 1'b1 : 1'b0; // A transitions
            endcase
        end
    end

    // Output is 1 when in state B
    assign out = ~state;

endmodule