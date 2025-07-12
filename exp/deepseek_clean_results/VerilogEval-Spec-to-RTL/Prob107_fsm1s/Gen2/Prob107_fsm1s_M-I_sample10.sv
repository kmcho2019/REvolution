module TopModule (
    input clk,
    input reset,
    input in,
    output out
);

    // State register: 0=B (out=1), 1=A (out=0)
    reg state;

    // Combined state transition and output logic
    always @(posedge clk) begin
        if (reset) begin
            state <= 1'b0;  // Reset to state B (out=1)
        end else begin
            case (state)
                1'b0: state <= in ? 1'b0 : 1'b1;  // State B transitions
                1'b1: state <= in ? 1'b1 : 1'b0;  // State A transitions
            endcase
        end
    end

    // Output is directly the inverted state bit
    assign out = ~state;

endmodule