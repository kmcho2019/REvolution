module TopModule(
    input  clk,
    input  areset,
    input  in,
    output out
);

    // Define the states using an enum for readability
    enum logic [0:0] {
        A = 0,
        B = 1
    } state;

    // Sequential logic with asynchronous reset
    always_ff @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= B; // Asynchronously reset to state B
        end else begin
            case (state)
                A: state <= in? A : B; // State A transitions
                B: state <= in? B : A; // State B transitions
            endcase
        end
    end

    // Directly assign output based on the state
    assign out = state;

endmodule