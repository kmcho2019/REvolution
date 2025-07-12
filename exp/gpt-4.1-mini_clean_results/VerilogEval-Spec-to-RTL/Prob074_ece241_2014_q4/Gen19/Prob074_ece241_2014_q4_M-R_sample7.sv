module TopModule (
    input  clk,
    input  x,
    output z
);

    // Synchronous reset signal asserted only at first clock cycle
    reg reset = 1'b1;

    // Individual flip-flop outputs
    reg ff0, ff1, ff2;

    // Combinational D inputs for each flip-flop (according to gate logic)
    wire d0, d1, d2;

    // Gate logic for each flip-flop D input
    assign d0 = x ^ ff0;       // XOR gate: input x and ff0
    assign d1 = x & ~ff1;      // AND gate: input x and complement of ff1
    assign d2 = x | ~ff2;      // OR gate: input x and complement of ff2

    // Synchronous logic: reset flip-flops on first clock edge, then update
    always @(posedge clk) begin
        if (reset) begin
            // Reset flip-flops to zero
            ff0 <= 1'b0;
            ff1 <= 1'b0;
            ff2 <= 1'b0;
            reset <= 1'b0; // Deassert reset after first clock
        end else begin
            // Update flip-flops with computed D inputs
            ff0 <= d0;
            ff1 <= d1;
            ff2 <= d2;
        end
    end

    // Output z is the NOR of all three flip-flop outputs
    assign z = ~(ff0 | ff1 | ff2);

endmodule