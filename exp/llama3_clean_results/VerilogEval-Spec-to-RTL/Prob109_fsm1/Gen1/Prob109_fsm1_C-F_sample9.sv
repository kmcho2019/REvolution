module TopModule(
    input  clk,
    input  areset,
    input  in,
    output out
);

    // Define states
    reg state; // 1-bit signal to keep track of the current state
    parameter B = 1'b1;
    parameter A = 1'b0;

    // Next state logic
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= B; // Reset to state B
        end else begin
            case (state)
                A: state <= (in)? A : B; // A (0) --1--> A, A (0) --0--> B
                B: state <= (in)? B : A; // B (1) --1--> B, B (1) --0--> A
                default: state <= B; // Default to state B for any other condition
            endcase
        end
    end

    // Output logic
    assign out = state; // Out is directly derived from the state

endmodule