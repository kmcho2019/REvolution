module TopModule(
    input  clk,
    input  areset,
    input  in,
    output out
);

    logic state; // Current state (A=0, B=1)

    // Sequential logic with asynchronous reset
    always_ff @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= 1; // Asynchronously reset to state B
        end else begin
            if (state == 0) begin // State A
                state <= in ? 0 : 1; // Stay in A if in=1, move to B if in=0
            end else begin // State B
                state <= in ? 1 : 0; // Stay in B if in=1, move to A if in=0
            end
        end
    end

    // Directly assign output based on the state
    assign out = state;

endmodule