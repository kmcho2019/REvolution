module TopModule (
    input clk,  // clock signal
    input w,    // input from previous stage
    input R,    // value to load
    input E,    // enable shift
    input L,    // load value
    output Q    // output value
);

reg q;  // internal storage for output value
assign Q = q;  // assign internal storage to output

always @(posedge clk)  // trigger on positive edge of clock
    if (L) begin  // if load is asserted, load value
        q <= R;
    end else if (E) begin  // if enable shift is asserted, shift value
        q <= w;
    end else begin  // otherwise, retain current value
        q <= q;
    end

endmodule