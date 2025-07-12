module TopModule(
    input clk,  // clock signal
    input w,    // input from previous stage
    input R,    // value to load
    input E,    // enable shift
    input L,    // load signal
    output reg Q  // output of the stage
);

// Load R when L is asserted, otherwise use the value from the previous stage (w) if E is asserted
always @(posedge clk) begin
    if (L) begin
        Q <= R;
    end else if (E) begin
        Q <= w;
    end else begin
        // If neither load nor shift is enabled, hold the current value
        Q <= Q;
    end
end

endmodule