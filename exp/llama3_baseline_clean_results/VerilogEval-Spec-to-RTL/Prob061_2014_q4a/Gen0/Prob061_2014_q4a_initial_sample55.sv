module TopModule(
    input clk,  // clock
    input w,    // input from previous stage
    input R,    // value to load
    input E,    // enable shift
    input L,    // load signal
    output reg Q // output
);

always @ (posedge clk) begin
    if (L) begin
        // Load R when L is asserted
        Q <= R;
    end else if (E) begin
        // Shift in w when E is asserted and L is not
        Q <= w;
    end
end

endmodule