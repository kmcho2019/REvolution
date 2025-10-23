module TopModule(
    input clk, // clock signal
    input w,   // input from previous stage
    input R,   // value to load
    input E,   // enable shift
    input L,   // load signal
    output reg Q // output of current stage
);

always @(posedge clk) begin
    if (L) begin
        // if load signal is high, load the value R
        Q <= R;
    end else if (E) begin
        // if enable shift signal is high, shift the input w
        Q <= w;
    end
end

endmodule