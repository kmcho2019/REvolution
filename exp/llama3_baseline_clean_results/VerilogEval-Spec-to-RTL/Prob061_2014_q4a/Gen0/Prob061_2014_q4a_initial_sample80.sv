module TopModule(
    input clk,  // clock signal
    input w,    // input from previous stage
    input R,    // value to load
    input E,    // enable shift
    input L,    // load signal
    output reg Q  // output
);

always @(posedge clk) begin
    if (L) begin  // load value R
        Q <= R;
    end else if (E) begin  // shift in value w
        Q <= w;
    end
    // else do nothing, Q retains its current value
end

endmodule