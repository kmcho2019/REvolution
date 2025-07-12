module TopModule (
    input  clk,
    input  reset,
    input  j,
    input  k,
    output out
);

    // One-hot state encoding
    reg off_state, on_state;
    wire next_off, next_on;

    // Synchronous reset and state update
    always @(posedge clk) begin
        if (reset) begin
            off_state <= 1'b1;  // OFF state active on reset
            on_state  <= 1'b0;
        end else begin
            off_state <= next_off;
            on_state  <= next_on;
        end
    end

    // Next state logic
    // OFF state transitions: if j=1 go ON, else stay OFF
    // ON state transitions: if k=1 go OFF, else stay ON
    assign next_off = (off_state & ~j) | (on_state & k);
    assign next_on  = (off_state & j)  | (on_state & ~k);

    // Output logic: output = 1 if in ON state, else 0
    assign out = on_state;

endmodule