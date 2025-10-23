module TopModule (
    input  clk,
    input  areset,
    input  in,
    output out
);

    // Define the states
    enum logic [0:0] {
        A = 0,
        B = 1
    } state;

    // Sequential logic with asynchronous reset
    always_ff @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= B;
        end else begin
            case (state)
                A: state <= in ? A : B;
                B: state <= in ? B : A;
            endcase
        end
    end

    // Output logic directly reflects the state
    assign out = state;

endmodule