module TopModule(
    input  clk,
    input  areset,
    input  in,
    output out
);

    reg state; // Current state (A=0, B=1)

    // Directly update state based on current state and input
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= 1'b1; // Asynchronously reset to state B
        end else begin
            case ({state, in})
                2'b00: state <= 1'b1; // Transition from A to B if in=0
                2'b01: state <= 1'b0; // Transition from A to A if in=1
                2'b10: state <= 1'b0; // Transition from B to A if in=0
                2'b11: state <= 1'b1; // Transition from B to B if in=1
            endcase
        end
    end

    // Out is directly derived from the state
    assign out = state;

endmodule