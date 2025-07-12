module TopModule(
    input clk,
    input areset,
    input in,
    output out
);

    // State encoding
    localparam A = 1'b0;
    localparam B = 1'b1;

    reg state;

    // Asynchronous reset and state register update
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= B; // Reset to state B
        else
            state <= state ^ (~in);
    end

    // Output assigned directly from state (Moore output)
    assign out = (state == B);

endmodule