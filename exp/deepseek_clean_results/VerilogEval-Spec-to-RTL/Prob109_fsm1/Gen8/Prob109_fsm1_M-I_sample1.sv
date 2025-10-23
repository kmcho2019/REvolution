module TopModule (
    input clk,
    input areset,
    input in,
    output out
);

    // State register (0=A, 1=B)
    reg state;

    // State transitions and output
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= 1'b1;  // Reset to state B
        end
        else begin
            case (state)
                1'b0: state <= in ? 1'b0 : 1'b1;  // A transitions
                1'b1: state <= in ? 1'b1 : 1'b0;  // B transitions
            endcase
        end
    end

    // Output is simply the state value (B=1, A=0)
    assign out = state;

endmodule