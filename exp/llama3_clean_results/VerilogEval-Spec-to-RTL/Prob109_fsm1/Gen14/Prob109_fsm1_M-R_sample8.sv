module TopModule(
    input  clk,
    input  areset,
    input  in,
    output out
);

    logic state; // Binary encoded state (A=1'b0, B=1'b1)

    // Sequential logic with asynchronous reset
    always_ff @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= 1'b1; // Asynchronously reset to state B
        end else begin
            case (state)
                1'b0: state <= in? 1'b0 : 1'b1; // State A
                1'b1: state <= in? 1'b1 : 1'b0; // State B
            endcase
        end
    end

    // Directly assign output based on the state
    assign out = state;

endmodule