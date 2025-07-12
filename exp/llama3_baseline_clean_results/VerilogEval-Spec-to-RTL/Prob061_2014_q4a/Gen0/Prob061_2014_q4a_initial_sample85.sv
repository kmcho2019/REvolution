module TopModule(
    input clk,  // clock signal
    input w,   // input from previous stage
    input R,   // value to load
    input E,   // enable shift
    input L,   // load signal
    output reg Q  // output
);

always @(posedge clk) begin
    if (L) begin
        // Load the value from R when L is asserted
        Q <= R;
    end else if (E) begin
        // Shift in the value from w when E is asserted and L is not
        Q <= w;
    end else begin
        // If neither L nor E is asserted, hold the current value
        Q <= Q;
    end
end

endmodule