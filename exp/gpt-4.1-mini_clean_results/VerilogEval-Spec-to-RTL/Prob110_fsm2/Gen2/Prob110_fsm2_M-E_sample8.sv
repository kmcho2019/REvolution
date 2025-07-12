module TopModule (
    input  clk,
    input  areset,
    input  j,
    input  k,
    output out
);

    // One-hot encoded state bits
    reg off_state, on_state;

    // Asynchronous reset and state register update
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            off_state <= 1'b1;
            on_state  <= 1'b0;
        end else begin
            // Next state logic for OFF
            off_state <= (off_state & ~j) | (on_state & k);
            // Next state logic for ON
            on_state <= (off_state & j) | (on_state & ~k);
        end
    end

    // Output directly from ON state (Moore output)
    assign out = on_state;

endmodule