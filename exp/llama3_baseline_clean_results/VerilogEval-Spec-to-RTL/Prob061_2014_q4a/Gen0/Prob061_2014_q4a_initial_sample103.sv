module TopModule(
    input clk,  // clock signal
    input w,    // input from previous stage
    input R,    // value to load
    input E,    // enable shift
    input L,    // load signal
    output reg Q  // output of this stage
);

always @(posedge clk) begin
    if (L) begin
        // If load signal is high, load the value R into Q
        Q <= R;
    end else if (E) begin
        // If shift enable is high, shift the input w into Q
        Q <= w;
    end else begin
        // If neither load nor shift is enabled, retain the current value of Q
        Q <= Q;
    end
end

endmodule