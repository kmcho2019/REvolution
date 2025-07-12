module TopModule (
    input clk,
    input areset,
    input in,
    output out
);

    // State register (0=A, 1=B)
    reg state;
    wire next_state;

    // Next state logic (combinational)
    assign next_state = (state == 1'b0) ? (in ? 1'b0 : 1'b1)  // A transitions
                                     : (in ? 1'b1 : 1'b0);  // B transitions

    // State register (sequential)
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= 1'b1;  // Reset to state B
        end
        else begin
            state <= next_state;
        end
    end

    // Output is simply the state value (B=1, A=0)
    assign out = state;

endmodule