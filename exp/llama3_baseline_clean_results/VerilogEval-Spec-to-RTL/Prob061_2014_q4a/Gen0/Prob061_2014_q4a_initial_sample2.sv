module TopModule(
    input clk,  // Clock signal
    input w,    // Input from previous stage
    input R,    // Value to load
    input E,    // Enable shift
    input L,    // Load signal
    output Q     // Output of the flip-flop
);

reg q;  // Internal state of the flip-flop

// D Flip-flop with asynchronous load
always @(posedge clk) begin
    if (L) begin
        q <= R;  // Load value R when L is asserted
    end else if (E) begin
        q <= w;  // Shift in value w when E is asserted and L is not
    end
    // If neither condition is met, q retains its current state
end

assign Q = q;  // Output the state of the flip-flop

endmodule