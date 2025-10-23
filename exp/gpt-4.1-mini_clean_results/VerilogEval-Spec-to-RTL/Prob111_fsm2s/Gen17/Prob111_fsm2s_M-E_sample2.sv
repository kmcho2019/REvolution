module TopModule (
    input  clk,
    input  reset,
    input  j,
    input  k,
    output out
);

    reg off_state, on_state;

    // State flip-flops update with synchronous reset
    always @(posedge clk) begin
        if (reset) begin
            off_state <= 1'b1;  // OFF state active on reset
            on_state  <= 1'b0;
        end else begin
            off_state <= (off_state & ~j) | (on_state & k);
            on_state  <= (off_state & j)  | (on_state & ~k);
        end
    end

    // Output is high when ON state active (Moore output)
    assign out = on_state;

endmodule