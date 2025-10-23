module TopModule (
    input clk,
    input areset,
    input in,
    output out
);

    // State definitions with clear parameters
    reg state;
    localparam A = 1'b0;
    localparam B = 1'b1;

    // Optimized state machine with balanced transition logic
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= B;  // Asynchronous reset to state B
        end else begin
            case (state)
                A: state <= (in) ? A : B;  // Balanced conditional
                B: state <= (in) ? B : A;  // Same structure as above
            endcase
        end
    end

    // Direct output assignment for minimal logic
    assign out = state;

endmodule