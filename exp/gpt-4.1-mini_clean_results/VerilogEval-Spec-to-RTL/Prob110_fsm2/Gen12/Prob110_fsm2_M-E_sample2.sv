module TopModule(
    input  clk,
    input  areset,
    input  j,
    input  k,
    output out
);

// One-hot state encoding
reg off_state, on_state;
wire off_next, on_next;

// Next state logic
assign off_next = (off_state & ~j) | (on_state & k);
assign on_next  = (off_state & j)  | (on_state & ~k);

// State registers with async reset
always @(posedge clk or posedge areset) begin
    if (areset) begin
        off_state <= 1'b1;
        on_state  <= 1'b0;
    end else begin
        off_state <= off_next;
        on_state  <= on_next;
    end
end

// Output is high when ON state is asserted
assign out = on_state;

endmodule